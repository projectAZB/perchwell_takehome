import React from 'react';
import { useParams } from 'react-router-dom';

const Buildings = () => {
  const { clientId } = useParams();

  return (
    <div>
      <h1>Buildings for Client {clientId}</h1>
      {/* Add logic to fetch and display buildings */}
    </div>
  );
};

export default Buildings;
