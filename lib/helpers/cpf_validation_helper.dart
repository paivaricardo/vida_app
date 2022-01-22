class ValidarCPFHelper {
  static bool validarCPF(String? cpf) {
    if (cpf!.length < 14) {
      return false;
    }

    List<int> cpfDigits = cpf.split('')
        .where((element) => RegExp(r'\d').hasMatch(element))
        .map((element) => int.parse(element))
        .toList();

    // First digit validation
    int sumDigitos1oDigitoVerificador = 0;

    for(int i = 10; i >= 2; i--) {
      sumDigitos1oDigitoVerificador += cpfDigits[10 - i] * i;
    }

    int primeiroDigitoVerificador = (sumDigitos1oDigitoVerificador * 10) % 11;
    primeiroDigitoVerificador = primeiroDigitoVerificador == 10 ? 0 : primeiroDigitoVerificador;

    // Second digit validation
    int sumDigitos2oDigitoVerificador = 0;

    for(int i = 11; i >= 2; i--) {
      sumDigitos2oDigitoVerificador += cpfDigits[11 - i] * i;
    }

    int segundoDigitoVerificador = (sumDigitos2oDigitoVerificador * 10) % 11;
    segundoDigitoVerificador = segundoDigitoVerificador == 10 ? 0 : segundoDigitoVerificador;

    return (cpfDigits[9] == primeiroDigitoVerificador && cpfDigits[10] == segundoDigitoVerificador);

  }
}

