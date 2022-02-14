import 'package:flutter/material.dart';

class TermoAceiteTratamentoDadosPessoais extends StatelessWidget {
  const TermoAceiteTratamentoDadosPessoais({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Text('TERMO DE ACEITE PARA TRATAMENTO DE DADOS PESSOAIS', style: TextStyle(fontWeight: FontWeight.bold),),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text('Este termo visa o registro do consentimento livre, informado e inequívoco pela qual o usuário concorda com o tratamento de seus dados pessoais e dados pessoais sensíveis referentes à saúde para finalidades específicas de pesquisa, em cumprimento às disposições da Lei nº 13.709/2018 – Lei Geral de Proteção de Dados Pessoais (LGPD).'),
        ),
        Text('Ao aceitar o presente termo, o usuário consente e concorda que a Universidade Federal do Amapá (UNIFAP) Instituição de Educação Superior (IES) localizada na Rodovia Josmar Chaves Pinto, km 02 - Jardim Marco Zero, CEP nº 68.903-419, Curso de Farmácia – Laboratório de Análises de clínicas 2, no município de Macapá, no estado do Amapá, mantida pela Fundação Universidade Federal do Amapá, pessoa jurídica de direito público – Federal, inscrita no Cadastro Nacional da Pessoa Jurídica (CNPJ) sob o nº 34.868.257/0001-81, endereço de e-mail madson@unifap.br, com sede no mesmo endereço da mantida, doravante denominada Controlador, tome decisões referentes ao tratamento de seus dados pessoais, bem como realize o tratamento de seus dados pessoais e dados pessoais sensíveis de saúde, envolvendo operações como as que se referem a coleta, produção, recepção, classificação, utilização, acesso, reprodução, transmissão, distribuição, processamento, arquivamento, armazenamento, eliminação, avaliação ou controle da informação, modificação, comunicação, transferência, difusão ou extração.'),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text('Dados pessoais e dados pessoais sensíveis', style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        Text('O Controlador fica autorizado a tomar decisões referentes ao tratamento e a realizar o tratamento dos seguintes dados pessoais do Titular:'),
        Text('- Nome completo'),
        Text('- Data de nascimento'),
        Text('- Sexo'),
        Text('- Escolaridade'),
        Text('- Profissão'),
        Text('- Peso atual'),
        Text('- Altura'),
        Text('- Conhecimento de Práticas Integrativas e Complementares em Saúde'),
        Text('- Questões de saúde específicas: ansiedade, depressão, dor e tabagismo/cessação tabágica'),
        Text('- Dados sobre a intensidade, frequência e início do tabagismo/cessação tabágica'),
        Text('- Dados sobre uso de medicamentos e quais medicamentos faz uso'),
        Text('- Dados complementares de saúde julgados necessário para fins de pesquisa e tratamento com Práticas Integrativas e Complementares em Saúde'),
        Text('- Resultados e pontuações alcançadas em questionários sobre ansiedade, depressão, dores e tabagismo/cessação tabágica, assim como apontamentos julgados necessários no momento da aplicação desses questionários'),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text('Finalidades do Tratamento dos Dados', style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        Text('O tratamento dos dados pessoais listados neste termo tem as seguintes finalidades:'),
        Text('- Possibilitar que o Controlador identifique o titular e levante dados para a condução de pesquisas sobre a aplicação de Práticas Integrativas e Complementares em Saúde (PICS) e seus efeitos sobre a saúde, em especial sobre ansiedade, depressão e tabagismo/cessação tabágica, condições cujos níveis serão mensurados por meio de aplicação de questionários sobre o Titular, durante atendimentos a serem realizados na unidade básica de saúde da Universidade Federal do Amapá (UNIFAP) ou no Laboratório de Análises Clínicas 2 (LAC-2) do Curso de Farmácia da UNIFAP.'),
        Text('- Possibilitar que o Controlador possa realizar estatísticas e levantamento de dados anonimizados e análises de tendência e regressão linear, para a finalidade exclusiva e pesquisa sobre o impacto da aplicação de Práticas Integrativas e Complementares em Saúde (PICS).'),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text('Compartilhamento de Dados', style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        Text('O Controlador não compartilhará os dados pessoais do Titular com outros agentes de tratamento de dados, exceto caso isso seja indispensável ao cumprimento das finalidades listadas neste termo, com o propósito exclusivo de pesquisa, excluídas finalidades comerciais, observados os princípios e as garantias estabelecidas pela Lei nº 13.709/2018.'),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text('Segurança dos Dados', style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        Text('O Controlador responsabiliza-se pela manutenção de medidas mínimas de segurança, que estejam ao seu alcance e capacidade técnica, aptas a proteger os dados pessoais de acessos não autorizados e de situações acidentais ou ilícitas de destruição, perda, alteração, comunicação ou qualquer forma de tratamento inadequado ou ilícito.'),
        Text('Em conformidade ao art. 48 da Lei nº 13.709/2018, o Controlador comunicará ao Titular e à Autoridade Nacional de Proteção de Dados (ANPD) a ocorrência de incidente de segurança que possa acarretar risco ou dano relevante ao Titular.'),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text('Término do Tratamento dos Dados', style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        Text('O Controlador poderá manter e tratar os dados pessoais do Titular durante todo o período em que os mesmos forem pertinentes ao alcance das finalidades listadas neste termo. Dados pessoais anonimizados, sem possibilidade de associação ao indivíduo, poderão ser mantidos por período indefinido.'),
        Text('O Titular poderá solicitar via e-mail ou mensagem ao Controlador, a qualquer momento, que sejam eliminados os dados pessoais não anonimizados do Titular.'),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text('Direitos do Titular', style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        Text('O Titular tem direito a obter do Controlador, em relação aos dados por ele tratados, a qualquer momento e mediante requisição: I – confirmação da existência de tratamento; II – acesso aos dados; III – correção de dados incompletos, inexatos ou desatualizados; IV – anonimização, bloqueio ou eliminação de dados desnecessários, excessivos ou tratados em desconformidade com o disposto na Lei nº 13.709/2018; V – portabilidade dos dados a outro fornecedor de serviço ou produto, mediante requisição expressa, de acordo com a regulamentação da autoridade nacional, observados os segredos comercial e industrial; VI – eliminação dos dados pessoais tratados com o consentimento do titular, exceto nas hipóteses previstas no art. 16 da Lei nº 13.709/2018; VII – informação das entidades públicas e privadas com as quais o controlador realizou uso compartilhado de dados; VIII – informação sobre a possibilidade de não fornecer consentimento e sobre as consequências da negativa; IX – revogação do consentimento, nos termos do § 5º do art. 8º da Lei nº 13.709/2018.'),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text('Direito de Revogação do Consentimento', style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        Text('Este consentimento poderá ser revogado pelo usuário, a qualquer momento, mediante solicitação via e-mail ou mensagem ao Controlador.'),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
            child: Text('ENTREGUE ESTE TERMO PARA A LEITURA DO PACIENTE. O TERMO DEVERÁ SER ASSINADO DIGITALMENTE PELO PRÓPRIO PACIENTE, COM A FERRAMENTA DE ASSINATURA ABAIXO.', style: TextStyle(fontWeight: FontWeight.bold),),
        ),
      ],
    );
  }
}
