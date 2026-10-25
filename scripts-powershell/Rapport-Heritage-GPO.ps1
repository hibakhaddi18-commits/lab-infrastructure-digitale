<#
.SYNOPSIS
    Affiche l'héritage des GPO d'une OU et génère un rapport RSoP au format HTML.

.DESCRIPTION
    Outil de diagnostic des stratégies de groupe : pour une unité d'organisation
    donnée, le script liste les GPO héritées et appliquées (dans l'ordre LSDOU :
    Local, Site, Domaine, OU) puis produit un rapport gpresult horodaté.

.EXAMPLE
    .\Rapport-Heritage-GPO.ps1 -OU "OU=tri,DC=isfo,DC=com"

.NOTES
    Auteur : Hiba Khaddi — Lab Infrastructure Digitale
    Prérequis : module GroupPolicy (RSAT ou contrôleur de domaine).
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$OU,

    [string]$DossierRapport = "$PSScriptRoot\rapports"
)

Import-Module GroupPolicy -ErrorAction Stop

# 1. Héritage des GPO sur l'OU cible (liens, ordre, blocages, "Appliqué")
Write-Host "=== Héritage GPO pour : $OU ===" -ForegroundColor Cyan
Get-GPInheritance -Target $OU | Format-List

# 2. Rapport RSoP détaillé au format HTML
if (-not (Test-Path $DossierRapport)) {
    New-Item -ItemType Directory -Path $DossierRapport | Out-Null
}
$nomFichier = "gpresult-" + (Get-Date -Format "yyyyMMdd-HHmm") + ".html"
$chemin = Join-Path $DossierRapport $nomFichier

gpresult /h $chemin /f
Write-Host "Rapport généré : $chemin" -ForegroundColor Green
