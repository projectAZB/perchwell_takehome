import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Clients from './Clients';
import CustomFields from './CustomFields';
import Buildings from './Buildings';

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Clients />} />
        <Route path="/clients/:clientId/custom_fields" element={<CustomFields />} />
        <Route path="/clients/:clientId/buildings" element={<Buildings />} />
      </Routes>
    </Router>
  );
};

export default App;
