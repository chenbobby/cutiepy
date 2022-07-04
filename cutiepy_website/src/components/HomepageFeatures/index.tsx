import React from "react";
import Link from "@docusaurus/Link";
import clsx from "clsx";
import styles from "./styles.module.css";

type FeatureItem = {
  title: string;
  description: JSX.Element;
};

const FeatureList: FeatureItem[] = [
  {
    title: "Run Python scripts on background workers.",
    description: (
      <>
        CutiePy allows you to turn any Python script into a background job. Your jobs can run immediately, at a later time, or repeatedly at a fixed interval.
        <br />
        <br />
        <Link to="/docs/quickstart" style={{ fontWeight: "bold" }}>Check out the quickstart guide.</Link>
      </>
    ),
  },
  {
    title: "Use the CutiePy UI to monitor jobs and workers.",
    description: (
      <>
        CutiePy ships with a real-time monitoring dashboard to help you track your jobs and workers.
        <br />
        <br />
        <Link to="/docs" style={{ fontWeight: "bold" }}>See more in the official documentation.</Link>
      </>
    ),
  },
  {
    title: "Permissive open source license",
    description: (
      <>
        CutiePy is released under the <a href="https://opensource.org/licenses/Apache-2.0">Apache-2.0 license</a>.
        <br />
        <br />
        <Link to="https://github.com/chenbobby/cutiepy" style={{ fontWeight: "bold" }}>See the source code on GitHub.</Link>
      </>
    ),
  },
];

function Feature({ title, description }: FeatureItem) {
  return (
    <div className={clsx("col col--4")}>
      <div className="text--center padding-horiz--md">
        <h3 style={{ textAlign: "left" }}>{title}</h3>
        <p style={{ textAlign: "left" }}>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures(): JSX.Element {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
