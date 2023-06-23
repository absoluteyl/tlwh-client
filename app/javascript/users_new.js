// the button to connect to an ethereum wallet
const buttonEthConnect = document.querySelector('button.eth_connect');

// the read-only eth address field, we process that automatically
const formInputEthAddress = document.querySelector('input.eth_address');
formInputEthAddress.hidden = true;

// get the user form for submission later
const formNewUser = document.querySelector('form.new_user');

// only proceed with ethereum context available
if (typeof window.ethereum !== 'undefined') {
  buttonEthConnect.addEventListener('click', async () => {
    buttonEthConnect.disabled = true;
    buttonEthConnect.innerText = "Connecting...";

    // request accounts from ethereum provider
    const accounts = await requestAccounts();

    // populate and submit form
    formInputEthAddress.value = accounts[0];
    formNewUser.submit();
  });
} else {
  // disable form submission in case there is no ethereum wallet available
  buttonEthConnect.innerHTML = "No Ethereum Context Available";
  buttonEthConnect.disabled = true;
}

// request ethereum wallet access and approved accounts[]
async function requestAccounts() {
  const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
  return accounts;
}
