
echo "Clonando o repositório base..."
git clone https://github.com/ANL-Software/base-app.git


echo ""
read -p "Digite o nome do seu projeto: " project_name

if [ -z "$project_name" ]; then
    echo "Nome do projeto não pode estar vazio!"
    exit 1
fi

echo ""
echo "Projeto '$project_name' será criado..."


if [ -d "base-app" ]; then
    mv base-app "$project_name"
    echo "Pasta renomeada para: $project_name"
else
    echo "Erro: Pasta base-app não encontrada!"
    exit 1
fi


cd "$project_name"


echo "Removendo vínculo com o repositório original..."
rm -rf .git

echo ""
echo "Alterando package name do Flutter..."
flutter pub run change_app_package_name:main com.andre.$project_name

## mudanca a analisar o nome do projeto para criar os flavors
echo ""
echo "Corrigindo bundle IDs dos flavors no iOS..."
sed -i '' "s/com\.andre\.base-app\.dev/com.andre.$project_name.dev/g" "ios/Runner.xcodeproj/project.pbxproj"
sed -i '' "s/com\.andre\.base-app\.stg/com.andre.$project_name.stg/g" "ios/Runner.xcodeproj/project.pbxproj"

echo ""
echo "Atualizando nome do app nos flavors (Android e iOS)..."
bash change_app_name.sh --base-name "$project_name" --all

flutter pub get

echo ""
echo "🎉 Configuração completa!"
echo "📁 Seu novo projeto '$project_name' está pronto para uso"
echo "📝 Instrução do projeto criada para a IA"
