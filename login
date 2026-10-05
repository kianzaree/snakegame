from flask import Flask, render_template, request, redirect, url_for, session, flash

app = Flask(__name__)

# کلید امنیتی برای مدیریت Sessionها (یک رشته تصادفی و دلخواه)
app.secret_key = 'super_secret_key_12345'

# دیتابیس ساده و تستی (در پروژه واقعی از SQLite/PostgreSQL استفاده می‌شود)
USERS = {
    "admin": "123456",
    "kian": "password123"
}

@app.route('/')
def home():
    # اگر کاربر قبلاً لاگین کرده باشد، مستقیم به داشبورد می‌رود
    if 'username' in session:
        return redirect(url_for('dashboard'))
    return redirect(url_for('login'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')

        # بررسی صحت نام کاربری و کلمه عبور
        if username in USERS and USERS[username] == password:
            session['username'] = username  # ذخیره نام کاربر در Session
            flash('با موفقیت وارد شدید!', 'success')
            return redirect(url_for('dashboard'))
        else:
            flash('نام کاربری یا رمز عبور اشتباه است.', 'danger')

    return render_template('login.html')

@app.route('/dashboard')
def dashboard():
    # محافظت از مسیر: فقط کاربران لاگین‌شده اجازه دسترسی دارند
    if 'username' not in session:
        flash('لطفاً ابتدا وارد حساب کاربری خود شوید.', 'warning')
        return redirect(url_for('login'))
    
    return render_template('dashboard.html', username=session['username'])

@app.route('/logout')
def logout():
    session.pop('username', None)  # حذف کاربر از Session
    flash('از حساب کاربری خارج شدید.', 'info')
    return redirect(url_for('login'))

if __name__ == '__main__':
    app.run(debug=True)
print ("be adab")