const metamask = window.ethereum;
let provider;

let signInButton;
let signOutButton;
let userData;

const signIn = async (connector) => {
  /**
     * Connects to the wallet and starts a etherjs provider.
  */
  if (connector === 'metamask') {
    await metamask.request({
      method: 'eth_requestAccounts',
    });
    provider = new ethers.providers.Web3Provider(metamask);
  }

  const [address] = await provider.listAccounts();
  if (!address) {
    throw new Error('Address not found.');
  }

  /**
     * Try to resolve address ENS and updates the title accordingly.
  */
  let ens;
  try {
    ens = await provider.lookupAddress(address);
  } catch (error) {
    console.error(error);
  }

  let { chainId } = await provider.getNetwork();

  /**
     * Gets the proper message from our backend
  */
  const message = await fetch('/siwe/message',
    {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': getCSRF(),
      },
      credentials: 'include',
      body: JSON.stringify({
        chainId,
        address,
      })
    }).then((res) => res.text());

  /**
     * Asks for the provider to sign our fresh message
  */
  const signature = await provider.getSigner().signMessage(message);

  /**
     * Calls the signature endpoint to validate the message and store
     * the result in the session for later completing the sign in.
  */
  await fetch(`/siwe/signature`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': getCSRF(),
    },
    credentials: 'include',
    body: JSON.stringify({ signature, ens }),
    redirect: 'follow',
  }).then(async (res) => {
    if (res.status === 200) {
      res.json().then(({ lastSeen, address, ens }) => {
        console.log(lastSeen, ens, address);
        connectedState(lastSeen, address, ens);
        return;
      });
    } else {
      res.json().then((err) => {
        console.error(err);
      });
    }
  });
};

const signOut = async () => {
  return fetch('/sign-out', {
    method: 'POST',
    credentials: 'include', headers: {
      'X-CSRF-Token': getCSRF(),
    }
  }).then(() => disconnectedState());
};

const connectedState = (lastSeen, address, ens) => {
  /**
   * Updates fields and buttons
   */
  signInButton.classList.add('hidden');

  signOutButton.addEventListener('click', signOut);
  signOutButton.classList.remove('hidden');

  const dt = luxon.DateTime.fromISO(lastSeen);
  const timestamp = dt.toLocaleString(luxon.DateTime.DATETIME_MED);

  console.log(ens, address);
  const user = ens || address;

  userData.innerText = `signed in as\n${user}\n\nlast seen at ${timestamp}`;
  userData.classList.remove('hidden');
};

const disconnectedState = () => {
  signInButton.classList.remove('hidden');
  signOutButton.classList.add('hidden');
  userData.classList.add('hidden');
};

const getCSRF = () => {
  return document.querySelector('meta[name="csrf-token"]').content;
};

document.addEventListener('DOMContentLoaded', () => {
  /**
   * Try to fetch user information and updates the state accordingly
   */
  fetch('/profile', {
    credentials: 'include', headers: {
      'X-CSRF-Token': getCSRF(),
    }
  }).then((res) => {
    if (res.status === 200) {
      res.json().then(({ lastSeen, address, ens }) => {
        connectedState(lastSeen, address, ens);
      });
    } else {
      /**
       * No session we need to enable signIn buttons
       */
      disconnectedState();
    }
  });

  /**
   * Bellow here are just helper functions to manage app state
   */
  signInButton = document.getElementById('sign-in');
  signInButton.addEventListener('click', () => signIn("metamask"));
  signOutButton = document.getElementById('sign-out');
  signOutButton.addEventListener('click', signOut);
  userData = document.getElementById('user-data');
});
