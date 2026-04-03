import 'package:base_app/common/services/http/http_service.dart';
import 'package:base_app/common/utils/base_response.dart';

/// DataSource responsável por buscar dados da Home de fontes remotas (API)
class HomeRemoteDataSource {
  const HomeRemoteDataSource(this._httpService);

  final HttpService _httpService;

  /// Busca os dados iniciais da home da API
  Future<BaseResponse> getHomeData() async {
    final response = await _httpService.get('/home');
    return response;
  }

  /// Busca dados atualizados da home da API
  Future<BaseResponse> refreshHomeData() async {
    final response = await _httpService.get('/home/refresh');
    return response;
  }

  /// Simula busca de dados para desenvolvimento/testes
  /// Remove este método em produção quando a API real estiver disponível
  Future<Map<String, dynamic>> getMockHomeData() async {
    // Simula delay de rede
    await Future<void>.delayed(const Duration(milliseconds: 800));

    return {
      'message': 'Bem-vindo ao Base App!',
      'items': ['Feature Counter', 'Configurações', 'Sobre'],
    };
  }
}
