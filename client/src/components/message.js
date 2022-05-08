import { useState, useEffect } from 'react'
import axios from 'axios';

export default function Message({
    handleChangeLoading,
    index,
    description,
    createAt,
    status,
    id
}) {
    const [isMessage, setIsMessage] = useState(false);
    const [deleteClick, setDeleteClick] = useState(false);
    const handleClickDelete = (value) => {
        setDeleteClick(value);
    }

    const handleClickEdit = (value) => {
        setIsMessage(value);
    }

    const ClickUpdateStatus = async (value) => {
        handleChangeLoading(false);
        try {
            const res = await axios.patch(`https://server-flutter2-ktm.herokuapp.com/v1/api/message/update/${id}`).then((res) => {
            console.log("success");
               
            })
                .catch((err) => {
            console.log("Failed");

                });
        }
        catch (err) {

            console.log("Failed");
        }
        handleChangeLoading(true);

    }

    const ClickDeleteMassage = async (value) => {
        handleChangeLoading(false);
        try {
            const res = await axios.delete(`https://server-flutter2-ktm.herokuapp.com/v1/api/message/delete/${id}`).then((res) => {
            console.log("success");
               
            })
                .catch((err) => {
            console.log("Failed");

                });
        }
        catch (err) {

            console.log("Failed");
        }
        handleChangeLoading(true);

    }

    return (
        <>
            {
                (isMessage || deleteClick) &&
                <div className="container-background">
                    <div className="form__food">
                        <div className="click">
                            <p
                                className="click_title"
                            >
                                Message
                            </p>
                            <p
                                className="click-x"
                                onClick={() => {
                                    setIsMessage(false);
                                    handleClickDelete(false)
                                    ClickUpdateStatus();
                                }
                                }
                            >
                                x
                            </p>
                        </div>
                        {isMessage && <p>
                            {description}
                        </p>}
                        {deleteClick && deleteClick && <div className="delete-food">
                                <button
                                    type="button"
                                    onClick={() => ClickDeleteMassage()}
                                    className="btn-food_delete"
                                >Delete
                                </button>
                                <button
                                    type="button"
                                    onClick={() => handleClickDelete(false)}
                                    className="btn-food_edit"
                                >cancel
                                </button>
                            </div>}
                    </div>
                </div>

            }
            <tr key={id}>
                <td style={{width: '5%'}}>{index}</td>
                <td style={{width: '25%'}}><span
                    id="msg_description"
                    onClick={() => handleClickEdit(true)}
                >{description}</span></td>
                <td>{createAt}</td>
                <td>{!status ? <span id="msg_new">new</span> : ""}</td>
                <td><button 
                    className="btn-food_delete"
                    onClick={() =>handleClickDelete(true)}
                >delete</button></td>
            </tr>
        </>

    )
}   
