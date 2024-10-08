<div>
    <h1>Documentation</h1>
    <h2>Overview</h2>
    <code>
            +---------------------+
            |     User Input      |
            +---------------------+
                     |
                     |
          +---------------------+
          |   Choose Web Server  |
          |   (1: Apache, 2: Nginx) |
          +---------------------+
                     |
             +-------+-------+
             |               |
        +----v----+    +-----v-----+
        |  Apache  |    |   Nginx   |
        |  Setup   |    |   Setup   |
        +----------+    +-----------+
             |                |
        +----+----+     +-----+-----+
        |  Install |     |  Install  |
        |  PHP &   |     |  PHP &    |
        | Extensions|     | Extensions|
        +-----------+     +-----------+
             |                |
        +----+----+     +-----+-----+
        | MySQL    |     | MySQL     |
        | Install  |     | Install   |
        +----------+     +-----------+
             |                |
             +-------+--------+
                     |
             +-------v--------+
             |  Create Directories |
             |  and Config Files   |
             +---------------------+
                     |
             +-------v--------+
             | Clone Git Repo  |
             +-----------------+
                     |
             +-------v--------+
             |   Restart Web   |
             |     Server      |
             +-----------------+
                     |
             +-------v--------+
             |   Set Ownership  |
             +-----------------+
                     |
             +-------v--------+
             |   Setup Complete  |
             +------------------+

    </code>
    <p>The <code>setup.sh</code> script automates the installation and configuration of a web server environment on a fresh Ubuntu server. It installs Apache, PHP, MySQL, and Composer, and sets up a virtual host for a specified domain.</p>
    <h2>Prerequisites</h2>
    <ul>
        <li><strong>Ubuntu Server</strong>: The script is designed for Ubuntu systems.</li>
        <li><strong>Root Access</strong>: You need to have root or sudo privileges on the server.</li>
        <li><strong>Domain Name</strong>: You should have a domain name that you want to point to this server.</li>
    </ul>
    <h2>Steps to Run the Script</h2>
    <h3>1. Connect to Your Server</h3>
    <p>Use SSH to connect to your server:</p><pre class="!overflow-visible"><div class="dark bg-gray-950 contain-inline-size rounded-md border-[0.5px] border-token-border-medium relative"><div class="flex items-center text-token-text-secondary bg-token-main-surface-secondary px-4 py-2 text-xs font-sans justify-between rounded-t-md h-9">bash</div><div class="sticky top-9 md:top-[5.75rem]"><div class="absolute bottom-0 right-2 flex h-9 items-center"><div class="flex items-center rounded bg-token-main-surface-secondary px-2 font-sans text-xs text-token-text-secondary"><span data-state="closed"><button class="flex gap-1 items-center py-1"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="icon-sm"><path fill-rule="evenodd" clip-rule="evenodd" d="M7 5C7 3.34315 8.34315 2 10 2H19C20.6569 2 22 3.34315 22 5V14C22 15.6569 20.6569 17 19 17H17V19C17 20.6569 15.6569 22 14 22H5C3.34315 22 2 20.6569 2 19V10C2 8.34315 3.34315 7 5 7H7V5ZM9 7H14C15.6569 7 17 8.34315 17 10V15H19C19.5523 15 20 14.5523 20 14V5C20 4.44772 19.5523 4 19 4H10C9.44772 4 9 4.44772 9 5V7ZM5 9C4.44772 9 4 9.44772 4 10V19C4 19.5523 4.44772 20 5 20H14C14.5523 20 15 19.5523 15 19V10C15 9.44772 14.5523 9 14 9H5Z" fill="currentColor"></path></svg></button></span></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="!whitespace-pre hljs language-bash">ssh username@your-server-ip
</code></div></div></pre>
    <p>Replace <code>username</code> with your server username and <code>your-server-ip</code> with the server's IP address.</p>
    <h3>2. Download the Script</h3>
    <p>Use <code>curl</code> or <code>wget</code> to download the script to your server:</p><pre class="!overflow-visible"><div class="dark bg-gray-950 contain-inline-size rounded-md border-[0.5px] border-token-border-medium relative"><div class="flex items-center text-token-text-secondary bg-token-main-surface-secondary px-4 py-2 text-xs font-sans justify-between rounded-t-md h-9">bash</div><div class="sticky top-9 md:top-[5.75rem]"><div class="absolute bottom-0 right-2 flex h-9 items-center"><div class="flex items-center rounded bg-token-main-surface-secondary px-2 font-sans text-xs text-token-text-secondary"><span data-state="closed"><button class="flex gap-1 items-center py-1"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="icon-sm"><path fill-rule="evenodd" clip-rule="evenodd" d="M7 5C7 3.34315 8.34315 2 10 2H19C20.6569 2 22 3.34315 22 5V14C22 15.6569 20.6569 17 19 17H17V19C17 20.6569 15.6569 22 14 22H5C3.34315 22 2 20.6569 2 19V10C2 8.34315 3.34315 7 5 7H7V5ZM9 7H14C15.6569 7 17 8.34315 17 10V15H19C19.5523 15 20 14.5523 20 14V5C20 4.44772 19.5523 4 19 4H10C9.44772 4 9 4.44772 9 5V7ZM5 9C4.44772 9 4 9.44772 4 10V19C4 19.5523 4.44772 20 5 20H14C14.5523 20 15 19.5523 15 19V10C15 9.44772 14.5523 9 14 9H5Z" fill="currentColor"></path></svg></button></span></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="!whitespace-pre hljs language-bash"><span class="hljs-comment"># Using curl</span>
sudo curl -O https://raw.githubusercontent.com/DevDhruvJoshi/PrecociousServerConfiguration/main/setup.sh

<span class="hljs-comment"># Or using wget</span>
sudo wget https://raw.githubusercontent.com/DevDhruvJoshi/PrecociousServerConfiguration/main/setup.sh
</code></div></div></pre>
    <h3>3. Make the Script Executable</h3>
    <p>Change the permissions to make the script executable:</p><pre class="!overflow-visible"><div class="dark bg-gray-950 contain-inline-size rounded-md border-[0.5px] border-token-border-medium relative"><div class="flex items-center text-token-text-secondary bg-token-main-surface-secondary px-4 py-2 text-xs font-sans justify-between rounded-t-md h-9">bash</div><div class="sticky top-9 md:top-[5.75rem]"><div class="absolute bottom-0 right-2 flex h-9 items-center"><div class="flex items-center rounded bg-token-main-surface-secondary px-2 font-sans text-xs text-token-text-secondary"><span data-state="closed"><button class="flex gap-1 items-center py-1"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="icon-sm"><path fill-rule="evenodd" clip-rule="evenodd" d="M7 5C7 3.34315 8.34315 2 10 2H19C20.6569 2 22 3.34315 22 5V14C22 15.6569 20.6569 17 19 17H17V19C17 20.6569 15.6569 22 14 22H5C3.34315 22 2 20.6569 2 19V10C2 8.34315 3.34315 7 5 7H7V5ZM9 7H14C15.6569 7 17 8.34315 17 10V15H19C19.5523 15 20 14.5523 20 14V5C20 4.44772 19.5523 4 19 4H10C9.44772 4 9 4.44772 9 5V7ZM5 9C4.44772 9 4 9.44772 4 10V19C4 19.5523 4.44772 20 5 20H14C14.5523 20 15 19.5523 15 19V10C15 9.44772 14.5523 9 14 9H5Z" fill="currentColor"></path></svg></button></span></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="!whitespace-pre hljs language-bash"><span class="hljs-built_in">sudo chmod</span> +x setup.sh
</code></div></div></pre>
    <h3>4. Run the Script</h3>
    <p>Execute the script:</p><pre class="!overflow-visible"><div class="dark bg-gray-950 contain-inline-size rounded-md border-[0.5px] border-token-border-medium relative"><div class="flex items-center text-token-text-secondary bg-token-main-surface-secondary px-4 py-2 text-xs font-sans justify-between rounded-t-md h-9">bash</div><div class="sticky top-9 md:top-[5.75rem]"><div class="absolute bottom-0 right-2 flex h-9 items-center"><div class="flex items-center rounded bg-token-main-surface-secondary px-2 font-sans text-xs text-token-text-secondary"><span data-state="closed"><button class="flex gap-1 items-center py-1"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="icon-sm"><path fill-rule="evenodd" clip-rule="evenodd" d="M7 5C7 3.34315 8.34315 2 10 2H19C20.6569 2 22 3.34315 22 5V14C22 15.6569 20.6569 17 19 17H17V19C17 20.6569 15.6569 22 14 22H5C3.34315 22 2 20.6569 2 19V10C2 8.34315 3.34315 7 5 7H7V5ZM9 7H14C15.6569 7 17 8.34315 17 10V15H19C19.5523 15 20 14.5523 20 14V5C20 4.44772 19.5523 4 19 4H10C9.44772 4 9 4.44772 9 5V7ZM5 9C4.44772 9 4 9.44772 4 10V19C4 19.5523 4.44772 20 5 20H14C14.5523 20 15 19.5523 15 19V10C15 9.44772 14.5523 9 14 9H5Z" fill="currentColor"></path></svg></button></span></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="!whitespace-pre hljs language-bash">sudo ./setup.sh
</code></div></div></pre>
    <p>The script will prompt you for various inputs during execution, such as your domain name and whether it’s a new server setup.</p>
    <h3>5. Follow the Prompts</h3>
    <ul>
        <li><strong>Enter Your Domain Name</strong>: You’ll be asked to input your domain name. You can hit Enter to use the default.</li>
        <li><strong>Check DNS Configuration</strong>: The script will check if your domain points to the server’s IP. If it doesn’t, you will be asked if you want to continue with the installation despite the DNS issue. Respond with <code>y</code> to proceed
            or <code>n</code> to exit.</li>
        <li><strong>Choose Installation Options</strong>: If it’s not a new server setup, you will have the option to install Apache, PHP, and MySQL.</li>
    </ul>
    <h2>Finalizing Installation</h2>
    <p>The script will perform the necessary installations and configurations. Once it finishes, you will see a completion message.</p>
    <p><strong>Run MySQL Secure Installation</strong>: After the setup, you will need to run the command <code>mysql_secure_installation</code> manually to secure your MySQL installation.</p>
    <h2>Expected Output</h2>
    <p>You will see messages indicating the progress of the installation, including updates, package installations, and configuration steps. Any errors will be displayed in red for easy identification.</p>
    <h2>Post-Installation</h2>
    <ul>
        <li><strong>Verify Apache Installation</strong>: Open your web browser and navigate to your server’s IP address or domain name. You should see a page indicating that the server is running.</li>
        <li><strong>Access Your Website</strong>: The document root for your domain is located at <code>/var/www/your-domain</code>, where you can place your web files.</li>
    </ul>
    <h2>Notes</h2>
    <ul>
        <li>Ensure that your domain’s DNS A record is pointing to your server’s public IP address before accessing it.</li>
        <li>It’s recommended to review firewall settings to ensure Apache is allowed to serve traffic (usually set up by the script).</li>
    </ul>
    <h2>Troubleshooting</h2>
    <p>If you encounter issues, check the Apache logs located at <code>/var/log/apache2/error.log</code> for errors. Ensure that your server is updated and that all necessary packages are available.</p>
    <h2>Conclusion</h2>
    <p>This script simplifies the process of setting up a web server environment. By following this documentation, users can quickly get their server ready for web hosting with the required software stack.</p>
</div>
