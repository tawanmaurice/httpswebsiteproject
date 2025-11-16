## HTTPS + Custom Domain with ALB, ACM, and Route 53

In the final phase of this project, I secured the application using HTTPS and a custom domain:

- **ACM (AWS Certificate Manager)**  
  - Requested a public certificate for `site.tawanperry.top`.
  - Used DNS validation with an automatic CNAME record in Route 53.
  - Waited for the certificate status to become **Issued** before attaching it to the load balancer.

- **Application Load Balancer (ALB)**  
  - Created an internet-facing ALB in my project VPC.
  - Configured:
    - **HTTP (80) listener** – forwards or redirects traffic.
    - **HTTPS (443) listener** – uses the ACM certificate and forwards to the target group.
  - Registered the Auto Scaling Group’s EC2 instances in the target group so they receive traffic.

- **Route 53 Alias Record**  
  - Added an **A (Alias)** record: `site.tawanperry.top` → ALB DNS name.
  - Enabled health checks via the ALB so traffic only goes to healthy instances.

**Result:**  
The application is now served over HTTPS at **https://site.tawanperry.top**, fronted by an Application Load Balancer, with automatic instance replacement and scaling handled by the Auto Scaling Group.
