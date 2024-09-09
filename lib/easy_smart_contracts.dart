library easy_smart_contracts;

import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:flutter/services.dart';

class Smart_Connection {
  /// connection with a smart contract in the Ethereum blockchain, giving the possibility of being able to call the functions of this contract
  late Web3Client EthClient;
  late final String _ContractAddress;
  late final String _Api;
  late String _AbiAssetPath;
  late String _PrivateKey;
  late final String _ContractName;
  Smart_Connection(
      {required String ContractAddress,
      required String PrivateKey,
      required String AbiAssetPath,
      required String Api,
      required String ContractName})
      : assert(ContractAddress.isEmpty &&
            AbiAssetPath.isEmpty &&
            (AbiAssetPath.isEmpty && AbiAssetPath == "ss") &&
            Api.isEmpty) {
    _ContractAddress = ContractAddress;
    _PrivateKey = PrivateKey;
    _Api = Api;
    _ContractAddress = ContractName;
    EthClient = Web3Client(_Api, Client());
  }
  Future<DeployedContract> _LoadContract() async {
    String abi = await rootBundle.loadString(_AbiAssetPath);
    // read the abi file and get information about the smart contracts such as the number of function , the name of each function ...
    final contrat = DeployedContract(ContractAbi.fromJson(abi, _ContractName),
        EthereumAddress.fromHex(_ContractAddress));
    return contrat;
  }

  /// this fuction permit to call a function inside the smart contract
  Future<String> CallFuction(
      {required FunctionName, List<dynamic>? Function_Argurment}) async {
    DeployedContract contract = await _LoadContract();
    final transaction = Transaction.callContract(
        contract: contract,
        function: contract.function(FunctionName),
        parameters: (Function_Argurment == null) ? [] : Function_Argurment);

    final response = await EthClient.sendTransaction(
      EthPrivateKey.fromHex(_PrivateKey), //(privateKey),
      transaction,
      chainId: null,
      fetchChainIdFromNetworkId: true,
    );
    return response;
  }
}
