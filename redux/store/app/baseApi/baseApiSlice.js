import { createApi, fetchBaseQuery } from "@reduxjs/toolkit/query/react";

const baseApiSlice = createApi({
    reducerPath: "baseApi",
    baseQuery: fetchBaseQuery({
        baseUrl: import.meta.env.API_URL, // or process.env.NEXT_PUBLIC_API_URL for nextjs
        credentials: "include",
    }),
    endpoints: (builder) => ({}),
});

export default baseApiSlice;
