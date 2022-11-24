## Warning

If this template is deployed for the first time you will have to follow these steps:

mkdir /var/lib/docker/volumes/traefik_data/  
mkdir /var/lib/docker/volumes/traefik_data/certs  
cd /var/lib/docker/volumes/traefik_data/certs  
-- Create your acme.json file here --  
chmod 600 ./acme.json  
cd /var/lib/docker/volumes/traefik_data  
-- Configure your traefik.yml here --  
