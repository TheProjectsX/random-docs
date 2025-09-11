// import baseApiSlice from "@/store/app/baseApi/baseApiSlice"; // for nextjs
import baseApiSlice from "../../app/baseApi/baseApiSlice";

const postsApiSlice = baseApiSlice.injectEndpoints({
    endpoints: (builder) => ({
        fetchPosts: builder.query({
            query: (params) => ({ url: "/posts", params }),
        }),
        updatePostUpvote: builder.mutation({
            query: ({ postId }) => ({
                url: `/posts/${postId}/upvote`,
                method: "PUT",
            }),
        }),
        updatePostDownvote: builder.mutation({
            query: ({ postId }) => ({
                url: `/posts/${postId}/downvote`,
                method: "PUT",
            }),
        }),
        reportPost: builder.mutation({
            query: ({ postId, body }) => ({
                url: `/posts/${postId}/report`,
                method: "POST",
                body,
            }),
        }),
    }),
});

export const {
    useFetchPostsQuery,
    useUpdatePostUpvoteMutation,
    useUpdatePostDownvoteMutation,
    useReportPostMutation,
} = postsApiSlice;

export default postsApiSlice;
