import logo from './logo.svg';
import './App.css';

import { useState, useEffect } from 'react';
import Message from "./components/message";
import axios from 'axios';
function App() {

  const [array, setArray] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [filterArray, setFilterArray] = useState([])

  useEffect(() => {
    callApi();
  }, [isLoading])

  const handleChangeLoading = (value)=>{
    setIsLoading(value);
  }

  const callApi = async () => {
    await axios.get(`https://server-flutter2-ktm.herokuapp.com/v1/api/message`)
      .then(res => {
        const persons = res.data;
        const filter = persons.filter((e)=>{return !e.readed});
        setArray(persons);
        setFilterArray(filter);
        console.log(persons);
      })
      .catch(err => {
        console.log("Failed")
      })
  }

  return (
    <div className="App">
      <h1>
        List messages <span>({filterArray.length})</span>
      </h1>
      <table>
        <thead>
          <tr>
            <th>#</th>
            <th>message</th>
            <th>date</th>
            <th>status</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {array.map((e, index)=><Message id={e._id} handleChangeLoading={handleChangeLoading} key={e._id} index={index} description={e.description} createAt={e.createdAt} status={e.readed} />)}
        </tbody>
      </table>
    </div>
  );
}

export default App;
