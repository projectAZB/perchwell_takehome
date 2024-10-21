import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Clients from './Clients';
import CustomFields from './CustomFields';
import Buildings from './Buildings';
import EditBuilding from './EditBuilding';
import AddBuilding from './AddBuilding';

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Clients />} />
        <Route path="/clients/:clientId/custom_fields" element={<CustomFields />} />
        <Route path="/clients/:clientId/buildings" element={<Buildings />} />
        <Route path="/clients/:clientId/buildings/:buildingId/edit" element={<EditBuilding />} />
        <Route path="/clients/:clientId/buildings/new" element={<AddBuilding />} />
      </Routes>
    </Router>
  );
};

export default App;
