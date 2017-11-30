App = {
  web3Provider: null,
  contracts: {},

  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {
    // Initialize web3 and set the provider to the testRPC.
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      console.log("no current provider");
      // set the provider you want from Web3.providers
      App.web3Provider = new web3.providers.HttpProvider('http://localhost:8545');
      web3 = new Web3(App.web3Provider);
    }
    //console.log("provider: " + App.web3Provider.path);
    return App.initContract();
  },

  initContract: function() {
    $.getJSON('NooCash.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract.
      var NooCashArtifact = data;
      App.contracts.NooCash = TruffleContract(NooCashArtifact);

      // Set the provider for our contract.
      App.contracts.NooCash.setProvider(App.web3Provider);

      // Use our contract to show the current account's balance
      return App.getBalances();
    });

    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '#transferButton', App.handleTransfer);
    $(document).on('click', '#mintButton', App.handleMint);
    $(document).on('click', '#burnButton', App.handleBurn);
  },

  handleTransfer: function() {
    event.preventDefault();

    var amount = parseFloat($('#TransferAmount').val());
    if (amount < 1000000)
    {
      amount *= 1000000000000000000;
    }
    var toAddress = $('#TransferAddress').val();

    console.log('Transfer ' + amount + ' NooCash to ' + toAddress);

    var NooCashInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
      // select main default account
      var account = accounts[0];

      App.contracts.NooCash.deployed().then(function(instance) {
        NooCashInstance = instance;

        return NooCashInstance.transfer(toAddress, amount, {from: account});
      }).then(function(result) {
        alert('Transfer Successful!');
        return App.getBalances();
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  },

  handleMint: function() {
    event.preventDefault();

    var amount = parseInt($('#MintAmount').val());
    // This token has 18 decimal places
    if (amount < 1000000)
    {
      amount *= 1000000000000000000;
    }
    var toAddress = $('#MintAddress').val();

    console.log('Mint ' + amount + ' NooCash for ' + toAddress);

    var NooCashInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
      // select main default account
      var account = accounts[0];
      console.log('...from: ' + account);

      App.contracts.NooCash.deployed().then(function(instance) {
        NooCashInstance = instance;

        return NooCashInstance.mint(toAddress, amount, {from: account});
      }).then(function(result) {
        alert('Minting Successful!');
        return App.getBalances();
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  },

  handleBurn: function() {
    event.preventDefault();

    var amount = parseInt($('#BurnAmount').val());
    if (amount < 1000000)
    {
      amount *= 1000000000000000000;
    }

    console.log('Burn ' + amount + ' NooCash.');

    var NooCashInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
      // select main default account
      var account = accounts[0];

      App.contracts.NooCash.deployed().then(function(instance) {
        NooCashInstance = instance;

        return NooCashInstance.burn(amount, {from: account});
      }).then(function(result) {
        alert('Burned ' + amount + ' NooCash! :(');
        return App.getBalances();
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  },

  getBalances: function(adopters, account) {
    console.log('Getting balances...');

    var NooCashInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];
      $('#AcctAddress').text(account);

      App.contracts.NooCash.deployed().then(function(instance) {
        NooCashInstance = instance;

        return NooCashInstance.totalSupply();
      }).then(function(result) {

        var supply = result / 1000000000000000000; // 18 decimal places
        $('#TotalSupply').text(supply);

        return NooCashInstance.balanceOf(account);
      }).then(function(result) {
        balance = result / 1000000000000000000; // 18 decimal places

        $('#AcctBalance').text(balance);
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
