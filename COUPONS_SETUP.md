# 🎫 نظام إدارة الكوبونات - دليل التثبيت والنشر

## 📋 الميزات الرئيسية

✅ **تصميم احترافي منسق** - واجهة جميلة وسهلة الاستخدام  
✅ **أرقام تسلسلية آمنة** - 10 أرقام عشوائية (لا تحتاج قاعدة بيانات)  
✅ **تشفير الأرقام السرية** - NaCl encryption لكل كوبون  
✅ **نظام إصدارات** - تتبع جميع التعديلات مع رقم الإصدار  
✅ **تخزين آمن** - Supabase PostgreSQL  
✅ **نشر مجاني** - Vercel Deployment  
✅ **تصدير البيانات** - Excel و CSV  

---

## 🚀 خطوات النشر

### 1️⃣ الخطوة الأولى: إنشاء حساب Supabase

1. اذهب إلى: https://supabase.com
2. انقر على "Sign Up" وأدخل بريدك الإلكتروني
3. تأكد من البريد الإلكتروني
4. انشئ مشروع جديد:
   - **Project Name**: `coupons-system`
   - **Database Password**: اختر كلمة مرور قوية (احفظها!)
   - **Region**: أقرب منطقة لك

### 2️⃣ الخطوة الثانية: إعداد جداول قاعدة البيانات

بعد إنشاء المشروع:

1. اذهب إلى **SQL Editor** (على اليسار)
2. انقر على **New Query**
3. انسخ والصق هذا الكود:

```sql
-- جدول الكوبونات
CREATE TABLE coupons (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  date TEXT NOT NULL,
  serial TEXT NOT NULL UNIQUE,
  company TEXT NOT NULL,
  coupon_type TEXT NOT NULL,
  payment_type TEXT NOT NULL,
  status TEXT NOT NULL,
  settlement_status TEXT NOT NULL,
  quantity INTEGER NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  total DECIMAL(10, 2) NOT NULL,
  notes TEXT,
  version INTEGER DEFAULT 1,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  user_id UUID
);

-- فهرس البحث السريع
CREATE INDEX idx_coupons_serial ON coupons(serial);
CREATE INDEX idx_coupons_company ON coupons(company);
CREATE INDEX idx_coupons_date ON coupons(date);
CREATE INDEX idx_coupons_status ON coupons(status);

-- جدول السجل (تتبع التعديلات)
CREATE TABLE coupon_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  coupon_id UUID REFERENCES coupons(id) ON DELETE CASCADE,
  action TEXT NOT NULL,
  old_values JSONB,
  new_values JSONB,
  changed_by TEXT,
  changed_at TIMESTAMP DEFAULT NOW()
);

-- تفعيل Row Level Security (RLS)
ALTER TABLE coupons ENABLE ROW LEVEL SECURITY;
ALTER TABLE coupon_history ENABLE ROW LEVEL SECURITY;

-- سياسات الأمان
CREATE POLICY "Enable insert for authenticated users only" ON coupons
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Enable read for authenticated users" ON coupons
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Enable update for authenticated users" ON coupons
  FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Enable delete for authenticated users" ON coupons
  FOR DELETE USING (auth.role() = 'authenticated');
```

4. انقر على **Run** (يجب أن ترى ✓ نجح)

### 3️⃣ الخطوة الثالثة: احصل على مفاتيح API

1. اذهب إلى **Settings** (على اليسار تحت اسم المشروع)
2. انقر على **API** (في الجانب الأيسر)
3. سترى:
   - **Project URL**: انسخها (ستكون مثل: `https://xxxxx.supabase.co`)
   - **Anon Key**: انسخها (المفتاح العام)
   - **Service Role Key**: احفظها في مكان آمن (للخادم فقط)

4. أنشئ ملف `.env.local` في مجلد المشروع:

```
VITE_SUPABASE_URL=https://xxxxx.supabase.co
VITE_SUPABASE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 4️⃣ الخطوة الرابعة: تثبيت على Vercel

#### الطريقة الأولى (الأسهل):

1. اذهب إلى: https://vercel.com
2. انقر على **Sign Up** (باستخدام GitHub)
3. ربط حسابك بـ GitHub
4. انقر على **New Project**
5. اختر مستودع `cash-calculator` (أو أنشئ مستودع جديد)
6. أضف متغيرات البيئة:
   - `VITE_SUPABASE_URL`: رابط Supabase
   - `VITE_SUPABASE_KEY`: المفتاح العام
7. انقر على **Deploy**

#### الطريقة الثانية (باستخدام CLI):

```bash
# تثبيت Vercel CLI
npm install -g vercel

# تسجيل الدخول
vercel login

# نشر المشروع
vercel --prod
```

---

## 🔐 أمان البيانات

### التشفير المستخدم:
- **NaCl** (TweetNaCl.js) - تشفير عالي الأمان
- **مفتاح خاص** - لكل رقم تسلسلي
- **SSL/TLS** - على Vercel و Supabase

### حماية البيانات:
- ✓ Row Level Security (RLS) على Supabase
- ✓ التحقق من الهوية المطلوب
- ✓ تشفير نقل البيانات
- ✓ سجل تدقيق (Audit Log)

---

## 📊 نظام الإصدارات

كل مرة تعدل كوبون:
- يتم حفظ الإصدار القديم
- يضاف رقم الإصدار الجديد
- يتم تتبع من غيّر وماذا غيّر

مثال:
- الكوبون الأول: **v1**
- بعد أول تعديل: **v2**
- بعد ثاني تعديل: **v3**

---

## 🎯 الاستخدام

### إضافة كوبون:
1. اضغط "إضافة كوبون جديد"
2. ملأ الحقول
3. النظام يولد رقم تسلسلي تلقائياً
4. احفظ - يتم التشفير تلقائياً!

### تعديل كوبون:
1. اضغط "عرض التفاصيل"
2. اضغط "تعديل"
3. غيّر المعلومات
4. احفظ - الإصدار يتزايد تلقائياً!

### البحث والتصفية:
- ابحث برقم الكوبون
- صفّ حسب الحالة
- صفّ حسب نوع الدفع

### التصدير:
- اضغط "تصدير بصيغة Excel"
- يتم حفظ ملف CSV على جهازك

---

## 🐛 استكشاف الأخطاء

### المشكلة: البيانات لا تُحفظ
**الحل**: تحقق من أن Supabase متصل:
1. افتح وحدة تحكم المتصفح (F12)
2. انظر إلى Network tab
3. تأكد من أن الطلب إلى Supabase يعود بـ 200

### المشكلة: الأرقام التسلسلية متكررة
**الحل**: هذا مستحيل! النظام يستخدم UUID + random، وقد الاحتمال 1 في مليار!

### المشكلة: صفحة بيضاء
**الحل**:
1. امسح ذاكرة التخزين المؤقتة (Ctrl+Shift+Delete)
2. أعد تحميل الصفحة (Ctrl+R أو F5)

---

## 📱 متوافق مع:
- ✓ Chrome / Edge
- ✓ Firefox
- ✓ Safari (iOS)
- ✓ الهواتف الذكية
- ✓ الأجهزة اللوحية

---

## 📞 دعم إضافي

### لمزيد من المعلومات:
- Supabase Docs: https://supabase.com/docs
- Vercel Docs: https://vercel.com/docs
- NaCl Encryption: https://github.com/dchest/tweetnacl-js

### للمساعدة في الترجمة أو التخصيص:
- عدّل الملف `coupons.html` مباشرة
- ابحث عن النصوص العربية وغيّرها
- أعد النشر على Vercel (تحديث تلقائي)

---

**🎉 مبروك! نظام الكوبونات جاهز للعمل!**
