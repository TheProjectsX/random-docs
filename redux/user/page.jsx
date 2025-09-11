import { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import {
    fetchUserInfoViaThunk,
    addUser,
    removeUser,
} from "../store/features/user/userSlice";
import {
    useFetchUserInfoQuery,
    useUpdateUserInfoMutation,
} from "../store/features/user/userApiSlice";

const UserPage = () => {
    const dispatch = useDispatch();

    // Redux state
    const users = useSelector((state) => state.user_info.data);
    const [newName, setNewName] = useState("");

    // RTK Query
    const { data: userInfo, isLoading } = useFetchUserInfoQuery();
    const [updateUser] = useUpdateUserInfoMutation();

    // Fetch users via Redux thunk on mount
    useEffect(() => {
        dispatch(fetchUserInfoViaThunk());
    }, [dispatch]);

    const handleAddUser = () => {
        dispatch(addUser({ id: Date.now(), name: newName }));
        setNewName("");
    };

    const handleUpdateInfo = async () => {
        await updateUser({ name: "Updated Name" });
    };

    return (
        <div>
            <h1>User Page</h1>

            <h2>Redux Users</h2>
            <input
                value={newName}
                onChange={(e) => setNewName(e.target.value)}
                placeholder="New user name"
            />
            <button onClick={handleAddUser}>Add User</button>
            <ul>
                {users.map((u) => (
                    <li key={u.id}>
                        {u.name}{" "}
                        <button onClick={() => dispatch(removeUser(u.id))}>
                            Remove
                        </button>
                    </li>
                ))}
            </ul>

            <h2>RTK Query User Info</h2>
            {isLoading ? (
                <p>Loading...</p>
            ) : (
                <div>
                    <p>Name: {userInfo?.name}</p>
                    <p>Email: {userInfo?.email}</p>
                    <button onClick={handleUpdateInfo}>Update Info</button>
                </div>
            )}
        </div>
    );
};

export default UserPage;
