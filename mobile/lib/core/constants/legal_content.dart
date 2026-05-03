import 'app_contact_info.dart';

/// Textos legais completos — apenas dentro da app.
abstract final class LegalContent {
  static String get termsOfUse => '$_termsRaw$_footer';

  static String get privacyPolicy => '$_privacyRaw$_footer';

  static String get _footer =>
      '\n\nÚltima atualização: ${AppContactInfo.lastUpdated}.\n'
      'Dúvidas: ${AppContactInfo.supportEmail}';

  static final String _termsRaw = '''
TERMOS DE USO DO ${AppContactInfo.appName}

1. Identificação
Estes Termos regulam o uso do aplicativo móvel ${AppContactInfo.appName} (“App”), disponibilizado para organização da vida a dois (tarefas, agenda, finanças, check-ins e funcionalidades associadas). Ao criar conta ou utilizar o App, declara que leu e aceita estes Termos.

2. Elegibilidade
O App destina-se a maiores de 18 anos. É responsável pela veracidade dos dados que indicar no registo e pela confidencialidade da sua palavra-passe.

3. Conta e parceiro
O ${AppContactInfo.appName} permite conectar duas contas num “Duo”. As informações partilhadas no contexto do casal ficam visíveis ao parceiro conectado, conforme a natureza de cada funcionalidade. É responsável por convidar apenas quem autorizou a partilhar esses dados.

4. Uso permitido
Compromete-se a utilizar o App de forma lícita, sem violar direitos de terceiros, sem difamar, sem introduzir malware ou interferir no funcionamento dos serviços. Podemos suspender ou encerrar contas em caso de uso abusivo ou ilegal.

5. Conteúdo e dados introduzidos por si
O conteúdo que regista (tarefas, notas, valores, comentários, etc.) é seu e do seu Duo. Concede ao ${AppContactInfo.appName} uma licença limitada, não exclusiva e revogável, estritamente necessária para alojar, processar e sincronizar esses dados na prestação do serviço.

6. Disponibilidade e alterações
Procuramos manter o App disponível, mas não garantimos funcionamento ininterrupto. Podemos alterar funcionalidades, estes Termos ou a Política de Privacidade; alterações relevantes serão indicadas na App quando razoável. O uso continuado após mudanças constitui aceitação, salvo disposição legal em contrário.

7. Limitação de responsabilidade
Na máxima extensão permitida pela lei aplicável, o ${AppContactInfo.appName} não responde por danos indiretos, lucros cessantes ou perda de dados decorrente de uso do App, salvo dolo ou culpa grave comprovada. Recomendamos cópias de segurança de informação crítica.

8. Rescisão
Pode deixar de utilizar o App a qualquer momento. Podemos encerrar ou suspender o serviço ou a sua conta com aviso quando aplicável. Pedidos de eliminação de dados pessoais são tratados conforme a Política de Privacidade e a lei.

9. Lei aplicável e litígios
Para utilizadores em Portugal, aplicam-se as leis portuguesas e europeias aplicáveis. Para litígios de consumo, são competentes os tribunais da sua área de residência habitual ou os tribunais indicados por lei.

10. Contacto
Para questões sobre estes Termos, utilize o e-mail indicado na secção “Contato” dentro da App.
''';

  static final String _privacyRaw = '''
POLÍTICA DE PRIVACIDADE DO ${AppContactInfo.appName}

1. Responsável pelo tratamento
O tratamento dos dados pessoais associados ao App ${AppContactInfo.appName} é efetuado no âmbito da prestação do serviço ao utilizador e ao respetivo Duo, em conformidade com o Regulamento (UE) 2016/679 (“RGPD”) e legislação nacional aplicável.

2. Que dados tratamos
• Dados de conta: nome, endereço de e-mail, credenciais de acesso (palavra-passe armazenada de forma segura).
• Dados de perfil e Duo: estado da relação (single/pending/connected), identificadores do casal, nome do parceiro quando aplicável.
• Dados que introduz na App: tarefas, eventos de agenda, registos financeiros que criar, check-ins emocionais, notas, missões e outros conteúdos que optar por guardar.
• Dados técnicos: tokens de dispositivo para notificações push (se autorizar), registos de diagnóstico agregados quando necessário para segurança.

3. Finalidades e bases legais
• Execução do contrato / medidas pré-contratuais: criar conta, sincronizar dados entre dispositivos e entre membros do Duo.
• Interesse legítimo: segurança, prevenção de abuso, melhoria técnica agregada do produto.
• Consentimento: quando solicitamos permissões específicas (ex.: notificações no sistema operativo).
• Obrigação legal: quando devamos conservar ou comunicar dados por imposição legal.

4. Partilha com o parceiro
Funcionalidades do casal implicam que determinadas informações que registe no contexto do Duo sejam visíveis ao parceiro conectado. Não vendemos os seus dados pessoais a terceiros.

5. Prestadores e transferências
Podemos utilizar prestadores de infraestrutura (ex.: alojamento de base de dados, serviços de autenticação ou envio de notificações) sob contratos que exigem proteção adequada dos dados. Se houver transferência para países fora do EEE, aplicar-se-ão garantias apropriadas (ex.: cláusulas tipo).

6. Conservação
Conservamos os dados pelo tempo necessário para prestar o serviço e cumprimento legal. Após pedido de eliminação de conta, eliminamos ou anonimizamos dados dentro de prazos razoáveis, salvo obrigações legais de arquivo.

7. Os seus direitos
Nos termos do RGPD, pode solicitar acesso, retificação, apagamento, limitação do tratamento, portabilidade e oposição, e retirar consentimentos quando aplicável. Também pode apresentar reclamação à autoridade de controlo competente (em Portugal, Comissão Nacional de Proteção de Dados).

8. Segurança
Utilizamos medidas técnicas e organizativas adequadas (incluindo comunicações encriptadas em trânsito quando aplicável à arquitetura). Nenhum sistema é totalmente invulnerável — utilize palavra-passe forte e não partilhe sessões.

9. Menores
O App não se destina a menores de 18 anos. Se tomar conhecimento de dados de menores, contacte-nos para os eliminar.

10. Alterações desta política
Podemos atualizar esta Política; a data da última versão aparece no final do documento na App. Recomendamos revisão periódica.

11. Contacto para privacidade
Para exercer direitos ou questões sobre dados pessoais, utilize o e-mail indicado na secção “Contato” dentro da App.
''';
}
