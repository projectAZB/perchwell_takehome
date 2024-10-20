import React from 'react';
import { useParams } from 'react-router-dom';

const CustomFields = () => {
  const { clientId } = useParams();

  return (
    <div>
      <h1>Custom Fields for Client {clientId}</h1>
      {/* Add logic to fetch and display custom fields */}
    </div>
  );
};

export default CustomFields;
