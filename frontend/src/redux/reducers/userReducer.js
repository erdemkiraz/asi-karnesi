import { SET_USER, SET_UNAUTHENTICATED, SET_LOADING_USER } from "../types";

const initialState = {
	isAuthenticated: false,
	isLoading: false,
	credentials: {
		fullname: "",
		email: "",
		image: "",
	},
};

export default function userReducer(state = initialState, action) {
	switch (action.type) {

		case SET_USER:
			return {
				...state,
				isAuthenticated: true,
				isLoading: false,
				credentials: {
					fullname: action.payload.fullname,
					email: action.payload.email,
					image: action.payload.image
				}
			}
		case SET_UNAUTHENTICATED:
			return {
				...state,
				isAuthenticated: false,
				isLoading: false,
				credentials: {
					fullname: "",
					email: "",
					image: "",
				}
			}
		
		case SET_LOADING_USER:
			return {
				...state,
				isLoading: false
			}
		default:
			return state;
	}
};