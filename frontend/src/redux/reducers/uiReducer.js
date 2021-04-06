import { SET_LOADING_UI, STOP_LOADING_UI } from "../types";

const initialState = {
    isLoading: true,
}

export default function uiReducer(state = initialState, action) {
    switch (action.type) {
        case SET_LOADING_UI:
            return {
                ...state,
                isLoading: true
            }
        
        case STOP_LOADING_UI:
            return {
                ...state,
                isLoading: false
            }
        default:
            return {...state}
    }
}