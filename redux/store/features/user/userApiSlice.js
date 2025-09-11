// import baseApiSlice from "@/store/app/baseApi/baseApiSlice"; // for nextjs
import baseApiSlice from "../../app/baseApi/baseApiSlice";

const userApiSlice = baseApiSlice.injectEndpoints({
    endpoints: (builder) => ({
        fetchUserInfo: builder.query({ query: () => "/me" }),
        updateUserInfo: builder.mutation({
            query: (data) => ({
                url: "/me",
                method: "PUT",
                body: data,
            }),
        }),
        fetchUserPosts: builder.query({
            query: (params) => ({
                url: "/me/posts",
                params,
            }),
        }),
        insertPost: builder.mutation({
            query: (data) => ({
                url: "/me/posts",
                method: "POST",
                body: data,
            }),
        }),
    }),
});

export const {
    useFetchUserInfoQuery,
    useUpdateUserInfoMutation,
    useFetchUserPostsQuery,
    useInsertPostMutation,
} = userApiSlice;

export default userApiSlice;
