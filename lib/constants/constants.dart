library constants;

const String LOCAL_STORAGE_TOKEN_KEY = 'token';
const String LOCAL_STORAGE_USER_KEY = 'user';

const String JSON_ACCESS_TOKEN_KEY = 'access_token';
const String JSON_DATA_KEY = 'data';
const String JSON_ERROR_KEY = 'error';
const String JSON_ROLE_KEY = 'role';
const String JSON_ACCEPT_TERMS_KEY = 'terms_accepted';
const String JSON_ID_KEY = 'id';

const int RESPONSE_SUCCESS = 200;
const int RESPONSE_SUCCESS_201 = 201;
const int EIGHT_WEEK_DAYS = 8 * 7;
const int EIGHT_WEEK_FIVE_DAYS = 8 * 5;

const String ERROR_MANDATORY_FIELD = 'O campo não pode estar vazio';
const String ERROR_INVALID_FORMAT_FIELD = 'Formato inválido';
const String ERROR_ADD_DRUG_FIELDS = 'Indique o nome e posologia';
const String ERROR_CONFIRMATION_PASS_MUST_BE_EQUAL =
    'Deve ser igual à password';
const String ERROR_NEW_PASS_MUST_NOT_BE_EQUAL =
    'Deve ser diferente da password atual';
const String ERROR_NEW_EMAIL_MUST_NOT_BE_EQUAL =
    'Deve ser diferente do email atual';
const String ERROR_NEGATIVE_VALUE = 'O valor deve ser positivo';
const String ERROR_INVALID_FRAGMENT = 'Index inválido';

const String ERROR_GENERAL_API = 'Woops! Algo correu mal';
const String ERROR_USER_NOT_FOUND_API = 'O utilizador não existe!';

// const BASE_URL = 'https://nutriclock.herokuapp.com';
const IMAGE_BASE_URL = 'https://nutriclock.s3-eu-west-1.amazonaws.com';
// const IMAGE_BASE_URL = 'https://ea25c14250e0.ngrok.io/storage';
const BASE_URL = 'https://9f5685e3b780.ngrok.io';
const BASE_API_URL = '$BASE_URL/api';
// wss://nutriclock-websocket.herokuapp.com
const WEBSOCKET_URL = 'wss://nutriclock-websocket.herokuapp.com';

const LOGIN_URL = '/login';
const LOGOUT_URL = '/logout';
const PASSWORD_URL = '/password';
const EMAIL_URL = '/email';
const REGISTER_URL = '/users';
const MEAL_URL = '/meals';
const MEALS_USER_URL = '/meals-user';
const MEALS_NAMES_URL = '/meal-names';
const MEALS_UPDATE_URL = '/meals-update';
const PHOTOS_URL = 'photo';

const USERS_ME_URL = '/users/me';
const USERS_AVATAR_URL = '/users/avatar';
const USERS_PROFILE_URL = '/users/profile';
const USERS_DISEASES_URL = '/users/diseases';

const USF_URL = '/ufcs';
const TERMS_URL = '/terms';
const DISEASES_URL = '/diseases';
const USER_TERMS_URL = '/users/terms';

const SLEEP_URL = '/sleeps';
const SLEEP_STATS_ME_URL = '/sleeps/myStats';

const STATS_URL = '/stats';
const CONFIG_TIP_URL = '/configs/tips';
const SLEEP_TIPS_URL = '/tips';
const SLEEP_DATES_URL = '/sleepsByDate';
const PROFESSIONALS_BY_USF = '/professionalsByUsf';
const MESSAGES_FROM_USER = '/messagesFromUser';
const MESSAGES = '/messages';
const MESSAGES_UNREAD_URL = '/messages/unread-count';

const MEDICATION_AUTH_URL = '/medications-auth';
const MEDICATIONS_URL = '/medications';

const EXERCISES_URL = '/exercises';
const EXERCISES_DATES_URL = '/exercises/dates';
const EXERCISES_DETAIL_URL = '/exercises/detail';
const EXERCISES_STATS_URL = '/exercises/stats';

const EXERCISES_LIST_URL = '/exercises/list';
const HOUSEHOLDS_URL = '/households';

const MEAL_PLAN_TYPE_URL = '/meal-types-patient';
const MEAL_PLAN_HISTORY_URL = '/meal-history-patient';

const FORGOT_ME = '/forgot-me';

const NOTIFICATION_URL = '/notifications';