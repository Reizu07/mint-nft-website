import { useState } from 'react';
import './App.css';
import MainMint from './MainMint';
import Navbar from './Navbar';


function App() {
  
  return (
  <div className="Overlay">
    <div className="App">
      <Navbar account={accounts} setAccounts={setAccounts}/>
      <MainMint account={accounts} setAccounts={setAccounts}/>
    </div>
    <div> className="background-image"</div>
  </div>
  );
}

export default App;
