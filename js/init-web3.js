// Padrão para detectar um web3 injetado.
window.addEventListener('load', function () {
    web3Provider = null;
    // Modern dapp browsers...
    if (window.ethereum) {
        web3Provider = window.ethereum;
        try {
            // Request account access
            window.ethereum.enable();
        } catch (error) {
            // User denied account access...
            console.error("User denied account access")
        }
    }
    // Legacy dapp browsers...
    else if (window.web3) {
        web3Provider = window.web3.currentProvider;
    }
    // If no injected web3 instance is detected, fall back to Ganache
    else {
        console.log('No web3? You should consider trying MetaMask!')
        web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(web3Provider);
})