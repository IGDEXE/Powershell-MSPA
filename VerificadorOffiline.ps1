# Script para verificar alteracoes em uma pasta
# Ivo Dias

# Link de referencia para o projeto:
# https://sergeluca.wordpress.com/2017/12/01/upload-and-run-a-remote-powershell-script-from-microsoft-flow/

$verificador = New-Object System.IO.FileSystemWatcher # Cria o verificador
$verificador.Path = "C:\OPS" # Define a pasta que ele vai verificar
$verificador.Filter = "*.*" # Coloca tudo como filtro
$verificador.IncludeSubdirectories = $true # Incluiu subdiretorios
$verificador.EnableRaisingEvents = $true  # Ativa a verificacao de eventos

# cria uma acao
$actionCreated = {
    write-host "Um arquivo foi criado"
    $path = $Event.SourceEventArgs.FullPath
    $name = $Event.SourceEventArgs.Name
    $changeType = $Event.SourceEventArgs.ChangeType
    $timeStamp = $Event.TimeGenerated
    write-host "Executando o script copiado para a pasta"
    Invoke-Expression "& '$path'"
    Remove-Item $path
    # Limpa a tela e finaliza
    Clear-Host
    Write-Host "Script executado com sucesso"
}
Register-ObjectEvent $verificador "Created" -Action $actionCreated

# Configura a exibicao
$host.ui.RawUI.WindowTitle = "ONLINE"
Clear-Host

while ($true) {sleep 1} # Aguarda 5 segundos para reiniciar