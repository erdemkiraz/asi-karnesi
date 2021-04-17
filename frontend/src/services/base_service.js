

function createUrl() {
    let port = 5000;
    // console.log(window.location.protocol)
    // return `${window.location.protocol}//${window.location.hostname}:${port}`;
    return `${window.location.protocol}//127.0.0.1:${port}`;
    // return "https://asi-karnesi.herokuapp.com";
}


export const BASE_URL = createUrl()
export var APIKEY = null;

export const clientId = "141610256272-jufso6co8s7bpq21hhaohkj36lu812nn.apps.googleusercontent.com";

export var HEADER = {
    'APIKEY': APIKEY
};

export function BUILD_HEADER() {
    return {
        'Access-Control-Allow-Origin': '*'
    };
}

export function getCurrentDate(separator = '') {

    let newDate = new Date()
    let date = newDate.getDate();
    let month = newDate.getMonth() + 1;
    let year = newDate.getFullYear();

    return `${year}${separator}${month < 10 ? `0${month}` : `${month}`}${separator}${date}`
}

// export function getUserEmail(google_user) {
//
//     if (google_user == null || google_user["profileObj"] == null ) return "null";
//     return google_user["profileObj"]["email"] ?? "null";
// }


export function getGoogleId(google_user) {
    if (google_user == null) return "null";
    return google_user["googleId"] + "" ?? "null";
}

// const AXIOS_CONFIG = {
//     baseUrl :BASE_URL,
//     withCredentials : true,
//     headers:{
//         'Accept' : 'application/json',
//         'Content-Type' : 'application/json',
//         'Access-Control-Allow-Origin': '*',
//     },
//     responseType : 'blob'
// }

// export const SERVICE_BASE  = axios.create(AXIOS_CONFIG);

export default function getUrl(path) {
    return BASE_URL + path
}