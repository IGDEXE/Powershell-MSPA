# Script para executar um script iniciado pelo MS Power Automate
# Ivo Dias

# Link de referencia para o projeto:
# https://sergeluca.wordpress.com/2017/12/01/upload-and-run-a-remote-powershell-script-from-microsoft-flow/

# Configuracoes gerais
$pastaLocal = "C:\OPS"
$pastaOneDrive = "$env:USERPROFILE\OneDrive - ESX\OPS"

# OneDrive
$verificadorOneDrive = New-Object System.IO.FileSystemWatcher # Cria o verificador
$verificadorOneDrive.Path = $pastaOneDrive # Define a pasta que ele vai verificar
$verificadorOneDrive.Filter = "*.*" # Coloca tudo como filtro
$verificadorOneDrive.IncludeSubdirectories = $true # Incluiu subdiretorios
$verificadorOneDrive.EnableRaisingEvents = $true  # Ativa a verificacao de eventos

# Pasta local
$verificadorLocal = New-Object System.IO.FileSystemWatcher # Cria o verificador
$verificadorLocal.Path = $pastaLocal # Define a pasta que ele vai verificar
$verificadorLocal.Filter = "*.*" # Coloca tudo como filtro
$verificadorLocal.IncludeSubdirectories = $true # Incluiu subdiretorios
$verificadorLocal.EnableRaisingEvents = $true  # Ativa a verificacao de eventos

# cria uma acao para o OneDrive
$actionOneDrive = {
    write-host "Um arquivo foi criado"
    $path = $Event.SourceEventArgs.FullPath
    $name = $Event.SourceEventArgs.Name
    $changeType = $Event.SourceEventArgs.ChangeType
    $timeStamp = $Event.TimeGenerated
    write-host "Copiando o arquivo $name para a pasta destino"
    Move-Item -Path $path -Destination "$pastaLocal"
}

# cria uma acao para executar
$actionLocal = {
    $path = $Event.SourceEventArgs.FullPath
    $name = $Event.SourceEventArgs.Name
    $changeType = $Event.SourceEventArgs.ChangeType
    $timeStamp = $Event.TimeGenerated
    write-host "Executando o script enviado pelo MS Power Automate"
    Invoke-Expression "& '$path'"
    Remove-Item $path
    # Limpa a tela e finaliza
    Clear-Host
    Write-Host "Script executado com sucesso"
}

Register-ObjectEvent $verificadorOneDrive "Created" -Action $actionOneDrive # Verifica se algo foi criado no OneDrive e copia para a pasta local
Register-ObjectEvent $verificadorLocal "Created" -Action $actionLocal # Se foi criado na pasta local, executa

# Configura a exibicao
$host.ui.RawUI.WindowTitle = "ONLINE"
Clear-Host

while ($true) {sleep 1} # Aguarda 1 segundos para reiniciar