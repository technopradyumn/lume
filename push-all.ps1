param (
    [string]$Message = "chore: sync project updates $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
)

Write-Host "==========================================================" -ForegroundColor Magenta
Write-Host "    LUME MULTI-REPO SYNC & PUSH TOOL                     " -ForegroundColor Magenta
Write-Host "    Commit message: '$Message'" -ForegroundColor Magenta
Write-Host "==========================================================" -ForegroundColor Magenta

# 1. Backend
Write-Host "`n[1/3] Updating Backend (lume_backend)..." -ForegroundColor Cyan
if ((git -C backend status --porcelain).Trim().Length -gt 0) {
    git -C backend add .
    git -C backend commit -m "$Message"
} else {
    Write-Host "  No uncommitted changes in backend." -ForegroundColor Gray
}
git -C backend push origin HEAD

# 2. Frontend
Write-Host "`n[2/3] Updating Frontend (lume_frontend)..." -ForegroundColor Cyan
if ((git -C frontend status --porcelain).Trim().Length -gt 0) {
    git -C frontend add .
    git -C frontend commit -m "$Message"
} else {
    Write-Host "  No uncommitted changes in frontend." -ForegroundColor Gray
}
git -C frontend push origin HEAD

# 3. Root Monorepo
Write-Host "`n[3/3] Updating Monorepo Root (lume)..." -ForegroundColor Cyan
if ((git status --porcelain).Trim().Length -gt 0) {
    git add .
    git commit -m "$Message"
} else {
    Write-Host "  No uncommitted changes in root monorepo." -ForegroundColor Gray
}
git push origin HEAD

Write-Host "`n==========================================================" -ForegroundColor Green
Write-Host " ✔ ALL REPOSITORIES ARE NOW FULLY UPDATED & PUSHED!      " -ForegroundColor Green
Write-Host "   https://github.com/technopradyumn/lume_backend" -ForegroundColor White
Write-Host "   https://github.com/technopradyumn/lume_frontend" -ForegroundColor White
Write-Host "   https://github.com/technopradyumn/lume" -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Green
