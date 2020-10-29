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

const String ERROR_MANDATORY_FIELD = 'O campo não pode estar vazio';
const String ERROR_INVALID_FORMAT_FIELD = 'Formato inválido';
const String ERROR_ADD_DRUG_FIELDS = 'Indique o nome e posologia';
const String ERROR_CONFIRMATION_PASS_MUST_BE_EQUAL = 'Deve ser igual à password';
const String ERROR_NEW_PASS_MUST_NOT_BE_EQUAL = 'Deve ser diferente da password atual';
const String ERROR_NEGATIVE_VALUE = 'O valor deve ser positivo';
const String ERROR_INVALID_FRAGMENT = 'Index inválido';

const String ERROR_GENERAL_API = 'Woops! Algo correu mal';
const String ERROR_USER_NOT_FOUND_API = 'O utilizador não existe!';

const BASE_URL = 'https://abb44a764bbd.ngrok.io';
const BASE_API_URL = '$BASE_URL/api';

const LOGIN_URL = '/login';
const LOGOUT_URL = '/logout';
const PASSWORD_URL = '/password';
const REGISTER_URL = '/users';
const MEAL_URL = '/meals';
const MEALS_USER_URL = '/meals-user';
const MEALS_NAMES_URL = '/meal-names';
const MEALS_STATS_URL = '/meals/stats';

const USERS_ME_URL = '/users/me';

const USF_URL = '/ufcs';
const TERMS_URL = '/terms';
const DISEASES_URL = '/diseases';
const USER_TERMS_URL = '/users/terms';