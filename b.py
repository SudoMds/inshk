import logging
import urllib.parse
import qrcode
from io import BytesIO
import subprocess
import requests
import sqlite3
from datetime import datetime, timedelta
from telegram import Update, InputFile
from telegram.ext import ApplicationBuilder, CommandHandler, ContextTypes
from telegram.helpers import escape_markdown

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# WGDashboard API Configuration
API_BASE_URL = "https://xx.ir/api/"
API_KEY = "mw77lLsssvsx8Ho3TRBR2qF1ZBrkx7MeGeiRprvP3Hd-mo"

HEADERS = {
    "Content-Type": "application/json",
    "wg-dashboard-apikey": API_KEY
}

DB_NAME = "peers.db"

conn = sqlite3.connect("users.db")
cursor = conn.cursor()

# ایجاد جدول Agent اگر وجود ندارد
cursor.execute("""
    CREATE TABLE IF NOT EXISTS Agent (
        name TEXT NOT NULL,
        UID INTEGER PRIMARY KEY,
        credit INTEGER,
        WGC TEXT NOT NULL
    )
""")
conn.commit()

def init_db_for_user(uid):
    """
    ایجاد دیتابیس و جدول برای کاربر خاص.
    """
    conn = sqlite3.connect(DB_NAME)
    cursor = conn.cursor()
    cursor.execute(f"""
        CREATE TABLE IF NOT EXISTS peers_{uid} (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            peer_name TEXT NOT NULL,
            public_key TEXT NOT NULL,
            private_key TEXT NOT NULL,
            allowed_ip TEXT NOT NULL,
            register_date DATE DEFAULT CURRENT_DATE NOT NULL,
            expiry DATE NOT NULL,
            status BOOLEAN DEFAULT TRUE NOT NULL
        )
    """)
    conn.commit()
    conn.close()

def generate_wireguard_keys():
    """
    Generate WireGuard keys (private and public).
    """
    private_key = subprocess.check_output(['wg', 'genkey']).decode('utf-8').strip()
    public_key = subprocess.check_output(['wg', 'pubkey'], input=private_key.encode('utf-8')).decode('utf-8').strip()
    return private_key, public_key

def add_days_to_current_date(days_to_add):
    """
    Calculate current date and expiry date.
    """
    current_date = datetime.now()
    new_date = current_date + timedelta(days=days_to_add)
    current_date_str = current_date.strftime('%Y-%m-%d')
    new_date_str = new_date.strftime('%Y-%m-%d')
    return current_date_str, new_date_str

def save_peer_to_db(peer_name, public_key, private_key, allowed_ip, days_to_add):
    """
    Save a peer's details to the database.
    """
    conn = sqlite3.connect(DB_NAME)
    cursor = conn.cursor()
    global uid
    # Calculate register_date and expiry
    register_date, expiry_date = add_days_to_current_date(days_to_add)
    cursor.execute(
        f"""
        INSERT INTO peers_{uid} (peer_name, public_key, private_key, allowed_ip, register_date, expiry)
        VALUES (?, ?, ?, ?, ?, ?)
        """,
        (peer_name, public_key, private_key, allowed_ip, register_date, expiry_date)
    )
    conn.commit()
    conn.close()

def delete_peer_from_db(peer_name):
    """
    Delete the peer entry from the database based on peer name.
    """
    conn = sqlite3.connect(DB_NAME)
    cursor = conn.cursor()
    cursor.execute(f"DELETE FROM peers_{uid} WHERE peer_name = ?", (peer_name,))
    conn.commit()
    conn.close()

def peer_name_exists(peer_name):
    """
    Check if a peer name already exists in the database (case-insensitive).
    """
    conn = sqlite3.connect(DB_NAME)
    cursor = conn.cursor()
    cursor.execute(f"SELECT 1 FROM peers_{uid} WHERE LOWER(peer_name) = LOWER(?)", (peer_name,))
    exists = cursor.fetchone() is not None
    conn.close()
    return exists

def get_public_key_from_db(peer_name):
    """
    Retrieve the public key for a given peer name from the database.
    """
    conn = sqlite3.connect(DB_NAME)
    cursor = conn.cursor()
    cursor.execute(f"SELECT public_key FROM peers_{uid} WHERE LOWER(peer_name) = LOWER(?)", (peer_name,))
    row = cursor.fetchone()
    conn.close()
    return row[0] if row else None

def get_expiry_date_from_db(peer_name):
    """
    Retrieve the expiry date for a given peer name from the database.
    """
    conn = sqlite3.connect(DB_NAME)
    cursor = conn.cursor()
    cursor.execute(f"SELECT expiry FROM peers_{uid} WHERE LOWER(peer_name) = LOWER(?)", (peer_name,))
    row = cursor.fetchone()
    conn.close()
    return row[0] if row else None

def decrease_credit_for_renew():
    conn = sqlite3.connect("users.db")
    cursor = conn.cursor()
    cursor.execute(f"UPDATE Agent SET credit = credit - (?) WHERE uid = (?)", (extend,uid,))
    conn.commit()
    conn.close()
    return True

""" def decrease_credit():
    conn = sqlite3.connect("users.db")
    cursor = conn.cursor()
    cursor.execute(f"UPDATE Agent SET credit = credit - (?) WHERE uid = (?)", (period,uid,))
    conn.commit()
    conn.close()
    return True """

def decrease_credit():
    try:
        with sqlite3.connect("users.db") as conn:
            cursor = conn.cursor()
            cursor.execute("UPDATE Agent SET credit = credit - ? WHERE uid = ?", (period, uid))
            conn.commit()
        return True
    except sqlite3.Error as e:
        print(f"An error occurred: {e}")
        return False

def get_wgc(uid):
    try:
        with sqlite3.connect("users.db", timeout=10) as connection:
            connection.execute("PRAGMA journal_mode=WAL;")
            cursor = connection.cursor()
            query = "SELECT WGC FROM agent WHERE uid = ?"
            cursor.execute(query, (uid,))
            result = cursor.fetchone()
            return result[0] if result else None
    except sqlite3.Error as e:
        print("An error occurred:", e)
        return None

def check_peer_status(uid,peer_name):
    try:
        with sqlite3.connect("peers.db", timeout=10) as connection:
            connection.execute("PRAGMA journal_mode=WAL;")
            cursor = connection.cursor()
            query = f"SELECT status FROM peers_{uid} WHERE peer_name = ?"
            cursor.execute(query, (peer_name,))
            result = cursor.fetchone()
            return result[0] if result else None
    except sqlite3.Error as e:
        print("An error occurred:", e)
        return None
    
def switch_status(uid,peer_name):
    try:
        with sqlite3.connect("peers.db", timeout=10) as connection:
            connection.execute("PRAGMA journal_mode=WAL;")
            cursor = connection.cursor()
            query = f"SELECT status FROM peers_{uid} WHERE peer_name = ?"
            cursor.execute(query, (peer_name,))
            result = cursor.fetchone()
            if result[0] == True:
                cursor.execute(f"UPDATE peers_{uid} SET status = False WHERE peer_name = ?", (peer_name,))
            else:
                cursor.execute(f"UPDATE peers_{uid} SET status = True WHERE peer_name = ?", (peer_name,))
    except sqlite3.Error as e:
        print("An error occurred:", e)
        return False


# Add a new command handler for the /start command
async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    global user, uid, username, full_name
    """
    Handle the /start command to send user information (UID and username).
    """
    user = update.message.from_user
    uid = user.id  # UID of the user
    username = user.username if user.username else "No username"
    full_name = user.full_name or f"{user.first_name} {user.last_name or ''}"

    init_db_for_user(uid)
    # Send a message to the user with their UID and username
    await update.message.reply_text(f"سلام {full_name} جان!\nشناسه تلگرامی شما: {uid}\nنام کاربری: {username}\nنمایندگی شما با موفقیت فعال شد")

async def check_add_permissions(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """
    بررسی دسترسی کاربر بر اساس UID و مقدار credit
    """
    global uid, credit, config_name
    uid = update.effective_user.id
    config_name = get_wgc(uid)

    # بررسی UID در جدول Agent
    cursor.execute("SELECT credit FROM Agent WHERE UID = ?", (uid,))
    result = cursor.fetchone()

    if result is None:
        # اگر UID موجود نباشد
        await update.message.reply_text("شما مجاز به استفاده از این ربات نیستید.")
        return False
    else:
        credit = result[0]
        if credit > 0:
            # پیام به کاربر در صورت وجود اعتبار
            await update.message.reply_text(f"اعتبار حساب شما پیش از تغییرات: {credit} ماه")
            return True
        else:
            # اگر اعتبار کاربر صفر باشد
            await update.message.reply_text("شما اعتبار کافی برای ساخت یا تمدید Peer را ندارید.")
            return False

async def check_uid(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """
    بررسی دسترسی کاربر بر اساس UID
    """
    global uid, config_name
    uid = update.effective_user.id
    config_name = get_wgc(uid)

    # بررسی UID در جدول Agent
    cursor.execute("SELECT uid FROM Agent WHERE UID = ?", (uid,))
    result = cursor.fetchone()

    if result is None:
        # اگر UID موجود نباشد
        await update.message.reply_text("شما مجاز به استفاده از این ربات نیستید.")
        return False
    else:
        return True


async def handle_any_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """
    هندلر عمومی برای دستورات ربات
    """

    global uid

    # اجرای دستورات
    command = update.message.text
    if command.startswith("/add "):
        has_permission = await check_add_permissions(update, context)
        if not has_permission:
            return  # دسترسی رد شد، اجرای دستور متوقف می‌شود.
        if await add_peer_command(update, context):
            if decrease_credit():
                await update.message.reply_text(f"اعتبار باقی مانده شما: {credit - period} ماه")
    elif command.startswith("/del "):
        has_uid = await check_uid(update, context)
        if not has_uid:
            return
        await delete_peer_command(update, context)
    elif command.startswith("/config "):
        has_uid = await check_uid(update, context)
        if not has_uid:
            return
        await download_peer_config(update, context)
    elif command.startswith("/link "):
        has_uid = await check_uid(update, context)
        if not has_uid:
            return
        await create_share_url(update, context)
    elif command.startswith("/showall"):
        has_uid = await check_uid(update, context)
        if not has_uid:
            return
        await show_peer_details(update, context)
    elif command.startswith("/renew "):
        has_permission = await check_add_permissions(update, context)
        if not has_permission:
            return  # دسترسی رد شد، اجرای دستور متوقف می‌شود.
        else:
            if await renew_peer(update, context):
                if decrease_credit_for_renew():
                    await update.message.reply_text(f"کاربر تمدید شد\nاعتبار باقی مانده شما: {credit - extend} ماه")
    else:
        await update.message.reply_text("دستور نامعتبر است.")

async def show_peer_details(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """
    نمایش جزئیات peers شامل نام، تاریخ ثبت، تاریخ انقضا، و روزهای باقی‌مانده.
    """

    # اتصال به دیتابیس
    conn = sqlite3.connect("peers.db")
    cursor = conn.cursor()

    # نام جدول مخصوص کاربر را می‌سازیم
    uid = update.effective_user.id
    table_name = f"peers_{uid}"

    try:
        # خواندن تمام رکوردهای جدول
        cursor.execute(f"SELECT peer_name, register_date, expiry FROM {table_name}")
        rows = cursor.fetchall()

        if not rows:
            await update.message.reply_text("❌ شما هیچ کاربری (Peer) ندارید.")
            return

        # پردازش و محاسبه روزهای باقی‌مانده
        now = datetime.now()
        message = "📋 *کاربران شما:*\n\n"

        # تعریف کاراکتر RLM برای اصلاح جهت
        RLM = "\u200F"

        for peer_name, register_date, expiry_date in rows:
            expiry = datetime.strptime(expiry_date, "%Y-%m-%d")
            days_left = (expiry - now).days
            if days_left < 0 :
                days_left = "غیر فعال"
            # فرار دادن کاراکترهای خاص برای Markdown
            peer_name_safe = escape_markdown(peer_name, version=2)
            register_date_safe = escape_markdown(register_date, version=2)
            expiry_date_safe = escape_markdown(expiry_date, version=2)

            # اضافه کردن RLM برای نمایش صحیح تاریخ‌ها
            message += (
                f"🔹 *نام:* {peer_name_safe}\n"
                f"📅 *تاریخ ثبت:* {RLM}{register_date_safe}\n"
                f"⏳ *تاریخ انقضا:* {RLM}{expiry_date_safe}\n"
                f"📆 *روزهای باقی‌مانده:* {RLM}{days_left}\n\n"
            )

        # ارسال پیام به تلگرام
        await update.message.reply_text(message, parse_mode="MarkdownV2")

    except sqlite3.Error as e:
        await update.message.reply_text(f"❌ خطا در ارتباط با دیتابیس: {e}")

    finally:
        conn.close()

async def add_peer_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """
    Handle the /addpeer command to add a peer via WGDashboard API and save it in the database.
    """
    global period

    if len(context.args) < 3:
        await update.message.reply_text(
            "❌ Please provide all required parameters.\n"
            "Usage: /add <peer_name> <allowed_ips> <period_in_month>\n"
            "Example: /add TestPeer 10.0.0.2/32 1"
        )
        return False

    peer_name = context.args[0]
    allowed_ips = context.args[1]
    period = context.args[2]
    
    period = int(period)
    days_to_add = period * 30

    if peer_name_exists(peer_name):
        await update.message.reply_text(
            f"❌ نام کاربری {peer_name} وجود دارد لطفا نام دیگری انتخاب کنید."
        )
        return False

    private_key, public_key = generate_wireguard_keys()

    url = f"{API_BASE_URL}/addPeers/{config_name}"
    payload = {
        "name": peer_name,
        "public_key": public_key,
        "private_key": private_key,
        "allowed_ips": [allowed_ips],
    }

    if period <= credit:
        try:
            response = requests.post(url, headers=HEADERS, json=payload)
            if response.status_code == 200:
                result = response.json()
                if result.get("status"):
                    save_peer_to_db(peer_name, public_key, private_key, allowed_ips, days_to_add)
                    await update.message.reply_text(
                        f"✅ کاربر با موفقیت ایجاد شد:\n"
                        f"نام کاربر: {peer_name}\nPublic Key: {public_key}\nAllowed IPs: {allowed_ips}"
                        )
                    return True
                else:
                    await update.message.reply_text(f"❌ ساخت کاربر جدید با مشکل مواجه شد: {result.get('message')}")
                    return False
            else:
                await update.message.reply_text(f"❌ خطا: {response.text}")
                return False
        except requests.exceptions.RequestException as e:
            await update.message.reply_text(f"❌ خطا در دریافت درخواست: {e}")
            return False
    else:
        await update.message.reply_text(f"❌ اعتبار شما برای ساختن اکانتی به مدت {period} ماه کافی نیست")
        return False

async def delete_peer_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """
    Handle the /del command to delete a peer via WGDashboard API and remove it from the database.
    """
    if len(context.args) < 1:
        await update.message.reply_text(
            "❌ Please provide the required parameters.\n"
            "Usage: /del <peer_name>\n"
            "Example: /del TestPeer"
        )
        return False

    peer_name = context.args[0]

    # Retrieve public key from the database
    public_key = get_public_key_from_db(peer_name)
    if not public_key:
        await update.message.reply_text(f"❌ کاربر {peer_name} وجود ندارد.")
        return False

    url = f"{API_BASE_URL}/deletePeers/{config_name}"
    payload = {"peers": [public_key]}

    try:
        response = requests.post(url, headers=HEADERS, json=payload)
        if response.status_code == 200:
            result = response.json()
            if result.get("status"):
                delete_peer_from_db(peer_name)
                await update.message.reply_text(f"✅ کاربر {peer_name} با موفقیت حذف شد.")
            else:
                await update.message.reply_text(f"❌ پاک کردن کاربر با خطا مواجه شد: {result.get('message')}")
        else:
            await update.message.reply_text(f"❌ خطا: {response.text}")
    except requests.exceptions.RequestException as e:
        await update.message.reply_text(f"❌ خطا در دریافت درخواست: {e}")

async def download_peer_config(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """
    Handle the /config command to retrieve the WireGuard configuration file for a peer and show it as plain text,
    QR code, and provide the configuration as a downloadable .conf file.
    """
    if len(context.args) < 1:
        await update.message.reply_text(
            "❌ Please provide the required parameters.\n"
            "Usage: /config <peer_name>\n"
            "Example: /config TestPeer"
        )
        return False

    peer_name = context.args[0]
    
    # Retrieve public key from the database
    public_key = get_public_key_from_db(peer_name)
    if not public_key:
        await update.message.reply_text(f"❌ کاربر {peer_name} وجود ندارد.")
        return False

    encoded_public_key = urllib.parse.quote(public_key)

    # Prepare the GET request URL
    url = f"{API_BASE_URL}/downloadPeer/{config_name}?id={encoded_public_key}"

    try:
        # Make the GET request to fetch configuration
        response = requests.get(url, headers=HEADERS)
        if response.status_code == 200:
            result = response.json()
            if result.get("status"):
                # Access nested "data" field and extract "file"
                data = result.get("data", {})
                config_data = data.get("file", "")
                if config_data:
                    # Generate the QR code
                    qr_image = BytesIO()
                    qr = qrcode.QRCode(version=1, box_size=10, border=4)
                    qr.add_data(config_data)
                    qr.make(fit=True)
                    qr_img = qr.make_image(fill="black", back_color="white")
                    qr_img.save(qr_image, format="PNG")
                    qr_image.seek(0)

                    # Send both plain text and QR code
                    readable_config = "\n".join(config_data.splitlines())
                    await update.message.reply_text(
                        f"✅ پیکربندی برای {peer_name}:\n```\n{readable_config}\n```",
                        parse_mode="Markdown"
                    )
                    await update.message.reply_photo(InputFile(qr_image, filename="wireguard_config.png"))

                    # Save the configuration as a .conf file
                    config_file = BytesIO()
                    config_file.write(config_data.encode('utf-8'))
                    config_file.seek(0)

                    # Send the configuration file as a downloadable .conf file
                    await update.message.reply_document(
                        document=InputFile(config_file, filename=f"{peer_name}_config.conf"),
                        caption="فایل کانفیگ وایرگارد برای کامپیوتر یا گوشی."
                    )
                else:
                    await update.message.reply_text(f"⚠️ Configuration file is empty for peer '{peer_name}'.")
            else:
                await update.message.reply_text(f"❌ دریافت پیکربندی با خطا مواجه شد: {result.get('message')}")
        else:
            await update.message.reply_text(f"❌ خطا: {response.text}")
    except requests.exceptions.RequestException as e:
        await update.message.reply_text(f"❌ خطا در دریافت درخواست: {e}")


async def create_share_url(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """
    Handle the /link command to generate a ShareID for a peer.
    """
    if len(context.args) < 1:
        await update.message.reply_text(
            "❌ Please provide all required parameters.\n"
            "Usage: /link <peer_name>\n"
            "Example: /link TestPeer"
        )
        return False

    # Extract arguments
    peer_name = context.args[0]

    # Retrieve public key from the database
    public_key = get_public_key_from_db(peer_name)
    if not public_key:
        await update.message.reply_text(f"❌ کاربر {peer_name} وجود ندارد.")
        return False

    # Calculate the expiration date
    expiration_date = (datetime.now() + timedelta(days=1)).strftime("%Y-%m-%d")

    # Prepare the POST request payload with the correct field names
    url = f"{API_BASE_URL}/sharePeer/create"  # Corrected URL for Share creation
    payload = {
        "Configuration": config_name,
        "Peer": public_key,
        "ExpireDate": expiration_date
    }
    
    try:
        # Send the POST request
        response = requests.post(url, headers=HEADERS, json=payload)

        if response.status_code == 200:
            result = response.json()

            # Log the response for debugging
            logger.info("API Response: %s", result)

            if result.get("status"):
                # Check if the response contains the 'data' field and 'shareid'
                data = result.get("data", [])
                if data:
                    share_id = data[0].get("ShareID", "")
                    if share_id:
                        share_url = f"https://wg.elfgame.ir/#/share?ShareID={share_id}"
                        await update.message.reply_text(
                            f"✅ لینک پیکربندی برای {peer_name}:\n{share_url}"
                        )
                    else:
                        await update.message.reply_text(f"⚠️ دریافت لینک کاربر {peer_name} با خطا مواجه شد.")
                else:
                    await update.message.reply_text("⚠️ خطا در دریافت اطلاعات از API.")
            else:
                await update.message.reply_text(f"❌ خطا در ساخت لینک: {result.get('message')}")
        else:
            await update.message.reply_text(f"❌ خطا: {response.text}")
    except requests.exceptions.RequestException as e:
        await update.message.reply_text(f"❌ خطا در دریافت درخواست: {e}")

async def renew_peer(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """
    Handle the /renew command to renew a peer via WGDashboard API.
    """

    if len(context.args) < 2 :
        await update.message.reply_text(
            "❌ Please provide all required parameters.\n"
            "Usage: /renew <peer_name> <period_in_month>\n"
            "Example: /renew TestPeer 1"
        )
        return False
    global extend
    peer_name = context.args[0]
    extend = context.args[1]

    extend = int(extend)
    days_to_add = extend * 30

    # Step 1: Check if peer exists in peers.db
    public_key = get_public_key_from_db(peer_name)
    if not public_key:
        await update.message.reply_text(f"❌ نام {peer_name} برای تمدید موجود نمی باشد.")
        return False

    # Step 5: Call the Allow Access API
    url = f"{API_BASE_URL}/allowAccessPeers/{config_name}"
    payload = {
        "peers" : [ public_key ]
    }
    status = check_peer_status(uid,peer_name)
    if not status:
        if extend <= credit:
            try:
                response = requests.post(url, headers=HEADERS, json=payload)
                if response.status_code == 200:
                    result = response.json()
                    if result.get("status"):
                        switch_status(uid,peer_name)
                        # Step 6: Update the expiry date in peers.db
                        expiry_date = datetime.now()
                        expiry_date = expiry_date.strftime("%Y-%m-%d")
                        current_expiry_date = datetime.strptime(expiry_date, "%Y-%m-%d")
                        new_expiry_date = current_expiry_date + timedelta(days_to_add)  # Approximation for 30 days per month
                        new_expiry_date_str = new_expiry_date.strftime("%Y-%m-%d")
                        conn = sqlite3.connect("peers.db")
                        cursor = conn.cursor()
                        cursor.execute(
                            f"UPDATE peers_{uid} SET expiry = ? WHERE LOWER(peer_name) = LOWER(?)",
                            (new_expiry_date_str, peer_name)
                        )
                        conn.commit()
                        conn.close()
                        RLM = "\u200F"
                        message = f"✅ تمدید کاربر {peer_name} با موفقیت انجام شد. تاریخ انقضا: {RLM}{new_expiry_date_str}"
                        message = escape_markdown(message, version=2)  # To ensure all special characters are escaped
                        await update.message.reply_text(message, parse_mode="MarkdownV2")
                        return True
                    else:
                        await update.message.reply_text(f"❌ تمدید کاربر با مشکل مواجه شد: {result.get('message')}")
                        return False
                else:
                    await update.message.reply_text(f"❌ API request failed with status {response.status_code}: {response.text}")
                    return False

            except requests.exceptions.RequestException as e:
                return update.message.reply_text(f"❌ خطا در دریافت درخواست: {e}")
        else:
            await update.message.reply_text(f"❌ اعتبار شما برای تمدید به مدت {period} ماه کافی نیست")
            return False
    elif status:
        if extend <= credit:
            # Step 6: Update the expiry date in peers.db
            expiry_date = get_expiry_date_from_db(peer_name)
            current_expiry_date = datetime.strptime(expiry_date, "%Y-%m-%d")
            new_expiry_date = current_expiry_date + timedelta(days_to_add)  # Approximation for 30 days per month
            new_expiry_date_str = new_expiry_date.strftime("%Y-%m-%d")
            conn = sqlite3.connect("peers.db")
            cursor = conn.cursor()
            cursor.execute(
                f"UPDATE peers_{uid} SET expiry = ? WHERE LOWER(peer_name) = LOWER(?)",
                (new_expiry_date_str, peer_name)
                )
            conn.commit()
            conn.close()
            RLM = "\u200F"
            message = f"✅ تمدید کاربر {peer_name} با موفقیت انجام شد. تاریخ انقضا: {RLM}{new_expiry_date_str}"
            message = escape_markdown(message, version=2)  # To ensure all special characters are escaped
            await update.message.reply_text(message, parse_mode="MarkdownV2")
            return True
        else:
            await update.message.reply_text(f"❌ اعتبار شما برای تمدید به مدت {period} ماه کافی نیست")
            return False
    else:
        await update.message.reply_text(f"❌ تمدید اشتراک با مشکل مواجه شد")




if __name__ == "__main__":

    TELEGRAM_BOT_TOKEN = "7673066111:AAFBVq1kzBUoxJwimfJZe-yrQF6Jgo115-g"
    app = ApplicationBuilder().token(TELEGRAM_BOT_TOKEN).build()

    app.add_handler(CommandHandler("start", start))
    app.add_handler(CommandHandler("renew", handle_any_command))
    app.add_handler(CommandHandler("showall", handle_any_command))
    app.add_handler(CommandHandler("add", handle_any_command))
    app.add_handler(CommandHandler("del", handle_any_command))
    app.add_handler(CommandHandler("config", handle_any_command))
    app.add_handler(CommandHandler("link", handle_any_command))

    print("Bot is running...")
    app.run_polling()
