// the button to connect to an ethereum wallet
const buttonEthConnect = document.querySelector('button.eth_connect');
const fieldEthMintResult = document.querySelector('p.eth_mint_result');
fieldEthMintResult.hidden = true;

// only proceed with ethereum context available
if (typeof window.ethereum !== 'undefined') {
  buttonEthConnect.addEventListener('click', async () => {
    buttonEthConnect.disabled = true;
    buttonEthConnect.innerText = "Minting...";

    // request accounts from ethereum provider
    const accounts = await requestAccounts();
    const account = accounts[0];

    const mintData = await getMintDataByAccount(account);
    if (mintData) {
      const ethTo = mintData[0];
      const ethData = mintData[1];

      // Send a transaction to the contract to mint a new token
      await ethereum.request({
        method: 'eth_sendTransaction',
        params: [{
          from: account,
          to: ethTo,
          data: ethData,
        }]
      })
      .then((txHash) => {
        fieldEthMintResult.innerHTML = "Your mint transaction is:" + txHash;
        fieldEthMintResult.hidden = false;

        buttonEthConnect.disabled = true;
        buttonEthConnect.hidden = true;
      })
      .catch((error) => {
        if (error.code === 4001) {
          fieldEthMintResult.innerHTML = "User denied transaction signature.";
          fieldEthMintResult.hidden = false;

          buttonEthConnect.innerText = "Mint";
          buttonEthConnect.disabled = false;
        } else {
          console.error(error)
        }
      });
    }
  });
} else {
  // disable form submission in case there is no ethereum wallet available
  fieldEthMintResult.innerHTML = "No Ethereum Context Available to mint.";
  fieldEthMintResult.hidden = false;

  buttonEthConnect.disabled = true;
}

// request ethereum wallet access and approved accounts[]
async function requestAccounts() {
  const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
  return accounts;
}

// get mintData from /api/v1/users/:id/mint by account
async function getMintDataByAccount(account) {
  const url = "/api/v1/users/" + account + "/mint"
  const response = await fetch(
    url, { method: "POST" }
  );
  const mintDataJson = await response.json();
  if (!mintDataJson) return null;
  return [mintDataJson[0].eth_to, mintDataJson[0].eth_data];
}
