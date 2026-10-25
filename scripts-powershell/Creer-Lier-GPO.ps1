<#
.SYNOPSIS
    Crée une GPO (si elle n'existe pas encore) et la lie à une ou plusieurs OU.

.DESCRIPTION
    Script d'administration Active Directory issu de mon lab Windows Server 2019
    (domaine isfo.com). Point important appris en TP : New-GPLink n'accepte pas
    les valeurs en position — il faut utiliser les paramètres nommés -Name et
    -Target, sinon PowerShell renvoie l'erreur "PositionalParameterNotFound".

.EXAMPLE
    .\Creer-Lier-GPO.ps1 -NomGPO "cmd-target" -OU "OU=tri,DC=isfo,DC=com","OU=ntic,DC=isfo,DC=com"

.EXAMPLE
    .\Creer-Lier-GPO.ps1 -NomGPO "Securite-Postes" -OU "OU=Postes,DC=isfo,DC=com" -Applique

.NOTES
    Auteur : Hiba Khaddi — Lab Infrastructure Digitale
    Prérequis : module GroupPolicy (RSAT ou contrôleur de domaine), droits d'administration du domaine.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$NomGPO,

    [Parameter(Mandatory = $true)]
    [string[]]$OU,

    # Si présent, la liaison est "Appliquée" (Enforced) : elle ne peut pas être
    # bloquée par une OU enfant et gagne en cas de conflit.
    [switch]$Applique
)

Import-Module GroupPolicy -ErrorAction Stop

# 1. Créer la GPO si elle n'existe pas encore
$gpo = Get-GPO -Name $NomGPO -ErrorAction SilentlyContinue
if (-not $gpo) {
    $gpo = New-GPO -Name $NomGPO
    Write-Host "GPO créée : $NomGPO" -ForegroundColor Green
}
else {
    Write-Host "GPO déjà existante : $NomGPO" -ForegroundColor Yellow
}

# 2. Lier la GPO à chaque OU cible
foreach ($cible in $OU) {
    $params = @{ Name = $NomGPO; Target = $cible }
    if ($Applique) { $params.Enforced = 'Yes' }

    New-GPLink @params
    Write-Host "Liaison créée vers : $cible" -ForegroundColor Cyan
}

Write-Host "Terminé. Vérification possible avec : Get-GPInheritance -Target <DN de l'OU>" -ForegroundColor Magenta
