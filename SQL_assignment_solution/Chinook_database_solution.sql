-- Exercise 1
-- Using the chinook database, write SQLite queries to answer the following questions in DB Browser. 

-- Q.1 What is the title of the album with AlbumId 67? 
 SELECT title FROM 'albums'
     WHERE AlbumId=7;

-- Q.2 Find the name and length (in seconds) of all tracks that have length between 50 and 70 seconds. 
 SELECT  name, milliseconds/1000 AS length FROM tracks WHERE Milliseconds/1000 BETWEEN 50 and 70;

-- Q.3 List all the albums by artists with the word ‘black’ in their name. 
 SELECT albums.Title FROM albums JOIN artists ON albums.ArtistId=artists.ArtistId WHERE albums.Title LIKE '%black%';

-- Q.4 Provide a query showing a unique/distinct list of billing countries from the Invoice table 
 SELECT DISTINCT billingcountry FROM invoices;

-- Q.5 Display the city with highest sum total invoice. 
 SELECT  BillingCity, ROUND(SUM(TOTAL), 0) as Total FROM invoices GROUP BY billingCity ORDER BY Total DESC LIMIT 1;


-- Q.6 Produce a table that lists each country and the number of customers in that country. (You only need to include countries that have customers) in descending order. (Highest count at the top)


 SELECT Country, COUNT(CustomerId) as customer_count FROM customers
GROUP BY Country
HAVING customer_count>0 
ORDER BY customer_count DESC;

-- Q.7 Find the top five customers in terms of sales i.e. find the five customers whose total combined invoice amounts are the highest. Give their name, CustomerId and total invoice amount. Use join 

 SELECT customers.FirstName|| ' ' || customers.LastName AS FullName, customers.customerId , SUM(invoices.total) FROM customers JOIN invoices ON customers.customerId=invoices.customerId GROUP BY customers.customerid ORDER BY TOTAL DESC LIMIT 5;


-- Q.8 Find out state wise count of customerID and list the names of states with count of customerID in decreasing order. Note:- do not include where states is null value. 
 SELECT State, Count(Customerid) AS customer_id FROM customers WHERE State IS NOT NULL GROUP BY State 
ORDER BY customer_id DESC;


-- Q.9 How many Invoices were there in 2009 and 2011? 
SELECT COUNT(InvoiceDate) AS COUNT, STRFTIME("%Y", InvoiceDate) AS Year FROM invoices WHERE InvoiceDate LIKE '2009%' OR InvoiceDate LIKE '2011%' GROUP BY STRFTIME("%Y", InvoiceDate); 


-- Q.10 Provide a query showing only the Employees who are Sales Agents. 
 SELECT  FirstName || ' '|| LastName AS Sales_Employee FROM 'employees' WHERE Title LIKE '%Sales Support Agent%';



-- Exercise 2
-- Using the chinook database, write SQLite queries to answer the following questions in DB Browser.

-- Q.1 Display Most used media types: their names and count in descending order.
SELECT media_types.Name AS media_type_name, Count(tracks.MediaTypeId) AS total_count FROM media_types JOIN 'tracks' WHERE  media_types.MediaTypeId=tracks.MediaTypeId GROUP BY media_types.MediaTypeId ORDER BY total_count DESC;
 
-- Q.2 Provide a query showing the Invoices of customers who are from Brazil. The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.
 SELECT customers.FirstName || ' ' || customers.LastName AS FullName, invoices.InvoiceId, invoices.InvoiceDate, invoices.billingCountry FROM customers JOIN invoices ON invoices.CustomerId=customers.CustomerId WHERE invoices.billingCountry='Brazil';

-- Q.3 Display artist name and total track count of the top 10 rock bands from dataset.
SELECT artists.Name AS artists_Name, COUNT(tracks.Name) as track_count FROM artists JOIN tracks, genres, albums ON artists.ArtistId= albums.ArtistId AND albums.AlbumId= tracks.AlbumId
AND genres.GenreId= tracks.GenreId
WHERE genres.GenreId=1
GROUP BY artists.Name
ORDER BY track_count DESC
LIMIT 10;

-- Q.4 Display the Best customer (in case of amount spent). Full name (first name and last name) 
 SELECT customers.FirstName || ' ' || customers.LastName AS FullName, ROUND(SUM(Total),0) AS total  FROM customers JOIN invoices ON customers.CustomerId= invoices.CustomerId  ORDER BY total DESC LIMIT 1;


-- Q.5 Provide a query showing Customers (just their full names, customer ID and country) who are not in the US. 
 SELECT customers.customerId, customers.FirstName ||' '|| customers.LastName AS FullName FROM customers WHERE Country NOT LIKE '%USA%';

-- Q.6 Provide a query that shows the total number of tracks in each playlist in descending order. The Playlist name should be included on the resultant table.
 SELECT playlists.Name, COUNT(playlist_track.trackid) AS total_track FROM playlist_track JOIN playlists ON playlists.playlistid=playlist_track.playlistid
    GROUP BY playlists.Name
    ORDER BY total_track DESC;

--  Q.7 Provide a query that shows all the Tracks, but displays no IDs. The result should include the Album name, Media type and Genre. 
 SELECT tracks.Name AS track_name, albums.Title AS title_name , media_types.Name AS media_type_name , genres.Name AS genres_Name FROM tracks JOIN albums, media_types, genres ON tracks.AlbumId=albums.AlbumId AND tracks.MediaTypeId=media_types.MediaTypeId AND tracks.GenreId=genres.GenreId;

-- Q.8 Provide a query that shows the top 10 bestselling artists. (In terms of earning). 
SELECT artists.name AS artists_name, SUM(invoice_items.Unitprice* invoice_items.quantity) as total_earnings FROM artists JOIN albums, tracks, invoices, invoice_items ON tracks.albumId= albums.albumId AND artists.artistId= albums.artistId AND invoices.InvoiceId= invoice_items.InvoiceId AND invoice_items.TrackId= tracks.TrackId GROUP BY artists.name ORDER BY total_earnings DESC LIMIT 10;

-- Q.9 Provide a query that shows the most purchased Media Type. 
 SELECT media_types.Name, COUNT(*) AS Total FROM media_types JOIN invoices, invoice_items, tracks ON tracks.MediaTypeId=media_types.mediaTypeId AND invoice_items.TrackId= tracks.TrackId AND invoices.InvoiceId= invoice_items.InvoiceId GROUP BY media_types.Name ORDER BY  Total DESC LIMIT 1;


-- Q.10 Provide a query that shows the purchased tracks of 2013. Display Track name and Units sold. 
 SELECT tracks.Name AS track_name, SUM(invoice_items.Quantity) AS total_quantity FROM tracks JOIN invoice_items, invoices ON tracks.TrackId=invoice_items.TrackId AND invoices.invoiceId=invoice_items.invoiceId WHERE  invoices.InvoiceDate LIKE '2013%' GROUP BY invoice_items.Quantity, tracks.Name; 
