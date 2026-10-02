# Git Push Script for Cash Calculator

Write-Host "🚀 بدء رفع الملفات إلى GitHub..." -ForegroundColor Green

# الخطوة 1: تفعيل credential helper
Write-Host "`n1️⃣ تفعيل حفظ بيانات GitHub..." -ForegroundColor Yellow
git config credential.helper store

# الخطوة 2: رفع الملفات
Write-Host "`n2️⃣ جاري رفع الملفات..." -ForegroundColor Yellow
git push https://github.com/matar456/cash-calculator.git main

# النتيجة
if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ تم الرفع بنجاح! موقعك الآن على GitHub" -ForegroundColor Green
    Write-Host "`n📍 الرابط: https://github.com/matar456/cash-calculator" -ForegroundColor Cyan
} else {
    Write-Host "`n❌ حدث خطأ! جرب مجدداً" -ForegroundColor Red
}

Write-Host "`n⏳ اضغط أي زر للإغلاق..." -ForegroundColor Gray
[System.Console]::ReadKey($true) | Out-Null
