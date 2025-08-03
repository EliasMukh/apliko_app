// ignore_for_file: constant_identifier_names

//! server
const _IP = 'https://api.notiot.ru';

const domain = _IP;

const _apiUrl = '$domain/api';

//! Auth
const loginUrl = '$_apiUrl/security/login';
const logoutUrl = '$_apiUrl/accounts/auth/basic/logout';
const registerUrl = '$_apiUrl/security/register';
const deleteAccountUrl = '$_apiUrl/accounts/auth/basic/delete-user-account';
const refreshTokenUrl = '$_apiUrl/accounts/session-reactivate/';
const profileUrl = '$_apiUrl/accounts/profile/user-profile';
const resetPasswordUrl = '$_apiUrl/email-sender/send-reset-password-email';

//! Devices
const getDevicesUrl = '$_apiUrl/devices'; // GET - للحصول على قائمة الأجهزة
const addDeviceUrl = '$_apiUrl/devices'; // POST - لإضافة جهاز جديد
const supersetDashboardLinkUrl = '$_apiUrl/superset-link';
//! Device Registration Key
const getDeviceRegKeyUrl =
    '$_apiUrl/devices'; // سيتم استكمالها بـ deviceId/regkey
// إضافة هذا السطر مع باقي URLs الخاصة بالأجهزة
const grantDeviceAccessUrl =
    '$_apiUrl/devices'; // سيتم استكمالها بـ deviceId/newuser
