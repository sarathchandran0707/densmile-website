# Densmile Dental Clinic — production image
# Serves the static site with nginx. Small, fast, and simple to health-check.

FROM nginx:alpine

# Remove the default nginx welcome page
RUN rm -rf /usr/share/nginx/html/*

# Copy the site into nginx's web root

COPY site/ /usr/share/nginx/html/


# nginx already listens on 80 by default in this image
EXPOSE 80

# Basic container-level health check — used locally and by the CI test step
HEALTHCHECK --interval=15s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q --spider http://localhost/ || exit 1
