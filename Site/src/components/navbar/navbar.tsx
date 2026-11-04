"use client";

import Link from "next/link";
import styles from "./navbar.module.css";

interface NavbarProps {
  icon: React.ReactNode;
  appName: string;
  links?: { label: string; href: string; external?: boolean }[];
  action: React.ReactNode;
}

export function Navbar({ icon, appName, links, action }: NavbarProps) {
  return (
    <>
      <div className={styles.spacer}></div>
      <div className={styles.navbarContainer}>
        <nav className={styles.navbar}>
          <div className={styles.content}>
            <Link className={styles.appIdentity} href="/">
              <div className={styles.appIconContainer}>{icon}</div>

              <div className={styles.appName}>{appName}</div>
            </Link>

            <ul className={styles.navLinks}>
              {links?.map((link) => {
                const href = link.href.startsWith("#")
                  ? `/${link.href}`
                  : link.href;

                return (
                  <li key={link.href} className={styles.navLinkItem}>
                    {link.external ? (
                      <a href={href}>{link.label}</a>
                    ) : (
                      <Link href={href}>{link.label}</Link>
                    )}
                  </li>
                );
              })}
            </ul>

            <div className={styles.action}>{action}</div>
          </div>
        </nav>
      </div>
    </>
  );
}
