import { createAsyncThunk, createSlice } from "@reduxjs/toolkit";
import userApiSlice from "./userApiSlice";

export const fetchUserInfoViaThunk = createAsyncThunk(
    "user_info/fetch",
    async (_, { dispatch }) => {
        const result = await dispatch(
            userApiSlice.endpoints.fetchUserInfo.initiate(
                {},
                { forceRefetch: true }
            )
        );
        if (result.isSuccess) return result.data;
        throw result.error;
    }
);

const initialState = {
    data: null,
    isLoading: true,
    isSuccess: false,
    isError: false,
    error: null,
};

const userInfoSlice = createSlice({
    name: "user_info",
    initialState,
    reducers: {
        addUser: (state, action) => state.data.push(action.payload),
        updateUser: (state, action) => {
            const index = state.data.findIndex(
                (u) => u.id === action.payload.id
            );
            if (index !== -1) state.data[index] = action.payload;
        },
        removeUser: (state, action) => {
            state.data = state.data.filter((u) => u.id !== action.payload);
        },
    },
    extraReducers: (builder) => {
        builder
            .addCase(fetchUserInfo.pending, (state) =>
                Object.assign(state, {
                    isLoading: true,
                    isSuccess: false,
                    isError: false,
                })
            )
            .addCase(fetchUserInfo.fulfilled, (state, action) =>
                Object.assign(state, {
                    isLoading: false,
                    isSuccess: true,
                    data: action.payload,
                })
            )
            .addCase(fetchUserInfo.rejected, (state, action) =>
                Object.assign(state, {
                    isLoading: false,
                    isError: true,
                    error: action.error?.message ?? "Failed to Load Info",
                })
            );
    },
});

export const { addUser, updateUser, removeUser } = userInfoSlice.actions;
export default userInfoSlice.reducer;
