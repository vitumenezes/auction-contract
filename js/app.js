var leilao;
var userAccount;
var actualAccount;

function startApp(){
    var contractAddress = '0x20f0FD75DC62967fB1D0E3e6cf0C9c21E79A1C00';

    var ok = document.getElementById("itens");

    leilao = new web3.eth.Contract(abi, contractAddress);

    var accountInterval = setInterval(function() {

        web3.eth.getAccounts().then(function (result) {
            actualAccount = result[0];
        })

        // Check if account has changed
        if (actualAccount !== userAccount) {
            userAccount = actualAccount;
            // Call some function to update the UI with the new account
            // $("#contractAddress").text("Your Account: " + userAccount);
            atualizarDados();
        }
    }, 100);
}

function dar_lance(id){
    var id = document.getElementById("item_id").value;
    var lance_atual = document.getElementById("item_lance_atual").value;
    var valor = 1000000000000000000*lance_atual;
    leilao.methods.dar_lance(id).send({ from: userAccount, value: valor });
    return false;
}

function mostrar_itens_disponiveis() {
    var ids = document.getElementById("item_id").value;
    $("#itens").empty();
    for (id of ids) {
    itens_disponiveis(id)
    .then((result) => {
        // Using ES6's "template literals" to inject variables into the HTML.
        const new_item = `
            <div class="zombie">
                <ul>
                    <li>Titulo: ${result.titulo}</li>
                    <li>Descrição: ${result.descricao}</li>
                    <li>Token: ${result.token}</li>
                </ul>
            </div>
        `;

        document.getElementById("itens").innerHTML = new_item;
    });
    }
}

function show_itens() {
    var count_itens_disponiveis = leilao.methods.itens_disponiveis().call();

    //table_tbody.empty();

    for (var i; i < count_itens_disponiveis; i++) {
        itens_disponiveis(i)
        .then((result) => {
            // Using ES6's "template literals" to inject variables into the HTML.
            const new_item = `
                <tr>
                    <td> ${result.titulo}</td>
                    <td> ${result.descricao}</td>
                    <td> ${result.lance_atual}</td>
                    <td> ${result.data_expiracao}</td>
                </tr>
            `;

            document.getElementsByTagName("tbody").innerHTML = new_item;
        });
    }
}

function itens_disponiveis(id){
    return leilao.methods.itens_disponiveis().call();
}

function adicionar_item(){
    var titulo = document.getElementById("item_titulo").value;
    var descricao = document.getElementById("item_descricao").value;
    var valor_inicial = document.getElementById("item_valor_inicial").value;

    var diferenca_minima = document.getElementById("item_valor_incremento").value;

    var data_expiracao = document.getElementById("item_data_expiracao").value;

    leilao.methods.adicionar_item(titulo, descricao, valor_inicial, diferenca_minima, data_expiracao).send({ from: userAccount });
    return false;

}

function atualizarDados(){
    document.getElementById("user-address").innerHTML = "Your Account: " + userAccount;
    show_itens();
}

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
    startApp()
})