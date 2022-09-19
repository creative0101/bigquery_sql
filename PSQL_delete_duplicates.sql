-- Delete duplicate value rows

DELETE FROM 
	shippers ship1
	USING shippers ship2
WHERE
	ship1.shipper_id > ship2.shipper_id
	AND ship1.company_name = ship2.company_name