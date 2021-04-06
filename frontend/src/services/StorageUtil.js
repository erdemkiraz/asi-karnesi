export function put_storage(key, value) {
    window.localStorage.setItem(key, JSON.stringify(value));
}


export function get_storage(key) {
    return JSON.parse(window.localStorage.getItem(key));
}

export function remove_key(key) {
    window.localStorage.removeItem(key)
}