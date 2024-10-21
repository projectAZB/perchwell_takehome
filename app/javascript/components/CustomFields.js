import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';

const CustomFields = () => {
  const [customFields, setCustomFields] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);
  const { clientId } = useParams();

  useEffect(() => {
    const fetchCustomFields = async () => {
      if (!clientId) {
        setError('Invalid client ID');
        setIsLoading(false);
        return;
      }

      setIsLoading(true);
      try {
        const response = await fetch(`/clients/${clientId}/custom_fields`);
        if (!response.ok) {
          throw new Error('Failed to fetch custom fields');
        }
        const data = await response.json();
        setCustomFields(data);
      } catch (err) {
        setError(err.message);
      } finally {
        setIsLoading(false);
      }
    };

    fetchCustomFields();
  }, [clientId]);

  if (isLoading) return <div>Loading custom fields...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <div>
      <h2>Custom Fields for Client {clientId}</h2>
      <Link to="/">Back to Clients List</Link>
      {customFields.length === 0 ? (
        <p>No custom fields found for this client.</p>
      ) : (
        <table style={{ width: '100%', borderCollapse: 'collapse' }}>
          <thead>
            <tr>
              <th style={{ border: '1px solid #ddd', padding: '8px', textAlign: 'left' }}>Name</th>
              <th style={{ border: '1px solid #ddd', padding: '8px', textAlign: 'left' }}>Value Type</th>
              <th style={{ border: '1px solid #ddd', padding: '8px', textAlign: 'left' }}>Value</th>
            </tr>
          </thead>
          <tbody>
            {customFields.map((field) => (
              <tr key={field.id}>
                <td style={{ border: '1px solid #ddd', padding: '8px' }}>{field.name}</td>
                <td style={{ border: '1px solid #ddd', padding: '8px' }}>{field.value_type}</td>
                <td style={{ border: '1px solid #ddd', padding: '8px' }}>{field.value}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
};

export default CustomFields;
