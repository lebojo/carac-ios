import { CardGrid } from "@/components/card_grid/card_grid";
import { DownloadActionButton } from "@/components/download_action_button/download_action_button";
import { Hero } from "@/components/hero/hero";
import { Section } from "@/components/section/section";
import { APP_ID, DOWNLOAD_LABEL } from "@/constants";
import { publicPath } from "@/lib/public_path";

import styles from "./page.module.css";

export default function Page() {
  return (
    <>
      <Section paddingTop={100}>
        <Hero
          title="Get stronger, one set at a time."
          subtitle="Carac is a simple, free strength training log for iPhone and iPad. Plan your week, log every set in seconds and watch your progress."
          media={
            <Hero.Image
              src={publicPath("/screenshots/iphone/01-home-light.jpg")}
              srcset={[{ src: publicPath("/screenshots/iphone/01-home-dark.jpg"), theme: "dark" }]}
              bezel="iPhone 17 Black"
              alt="Carac home screen with today's training and the week ahead"
            />
          }
          action={<DownloadActionButton size="medium" label={DOWNLOAD_LABEL} />}
        />
      </Section>

      <Section title="Everything you need at the gym" navigationAnchor="features">
        <CardGrid rowHeight={438}>
          <CardGrid.StackedCard
            maxWidth="third"
            title="Plan your week"
            description="Build trainings from your own exercises and give each one the days you train. Today's training waits on the home screen."
            media={
              <picture className={styles.previewCrop}>
                <source
                  media="(prefers-color-scheme: dark)"
                  srcSet={publicPath("/screenshots/iphone/06-trainings-dark.jpg")}
                />
                <img
                  src={publicPath("/screenshots/iphone/06-trainings-light.jpg")}
                  alt="List of trainings with the weekdays they are planned for"
                />
              </picture>
            }
            textAlignment="leading"
          />
          <CardGrid.StackedCard
            maxWidth="twoThirds"
            title="Log every set in seconds"
            description="Weight and reps with quick steppers. Your last values are already there and last time's best set is shown, so you only adjust what changed."
            media={
              <CardGrid.StackedCard.Image
                src={publicPath("/screenshots/iphone/02-exercise-light.jpg")}
                srcset={[{ src: publicPath("/screenshots/iphone/02-exercise-dark.jpg"), theme: "dark" }]}
                alt="Logging the weight and reps of each set of an exercise"
                bezel="iPhone 17 Black"
              />
            }
            textAlignment="leading"
          />
          <CardGrid.StackedCard
            maxWidth="twoThirds"
            title="Watch your progress"
            description="Every training gets a chart of the total weight lifted per session, with the total weight pulled, your best session, the average and its trend."
            layoutDirection="reverse"
            media={
              <CardGrid.StackedCard.Image
                src={publicPath("/screenshots/iphone/04-progress-light.jpg")}
                srcset={[{ src: publicPath("/screenshots/iphone/04-progress-dark.jpg"), theme: "dark" }]}
                alt="Chart of the total weight lifted per session for a training"
                bezel="iPhone 17 Black"
                bezelCrop={{ edge: "bottom", croppedRatio: 0.25 }}
              />
            }
            textAlignment="leading"
          />
          <CardGrid.StackedCard
            maxWidth="third"
            title="More room on iPad"
            description="Your trainings, sessions and statistics on a bigger screen."
            media={
              <picture className={styles.previewCrop}>
                <source
                  media="(prefers-color-scheme: dark)"
                  srcSet={publicPath("/screenshots/ipad/01-home-dark.jpg")}
                />
                <img
                  src={publicPath("/screenshots/ipad/01-home-light.jpg")}
                  alt="Carac home screen on iPad"
                />
              </picture>
            }
            textAlignment="leading"
          />
          <CardGrid.StackedCard
            maxWidth="full"
            title="Every session in your calendar"
            description="The stats tab shows a calendar of the days you trained, with the stats of each day and of all your training."
            media={
              <CardGrid.StackedCard.Image
                src={publicPath("/screenshots/iphone/05-calendar-light.jpg")}
                srcset={[{ src: publicPath("/screenshots/iphone/05-calendar-dark.jpg"), theme: "dark" }]}
                alt="Calendar of training sessions in the stats tab"
                bezel="iPhone 17 Black"
                bezelCrop={{ edge: "bottom", croppedRatio: 0.2 }}
              />
            }
            textAlignment="leading"
          />
        </CardGrid>
      </Section>

      <Section title="Your data, your devices">
        <CardGrid rowHeight={240}>
          <CardGrid.IconCard
            maxWidth="third"
            iconName="cloud_sync"
            title="Synced with iCloud"
            description="Your trainings and sessions follow you on iPhone and iPad through your own private iCloud."
          />
          <CardGrid.IconCard
            maxWidth="third"
            iconName="favorite"
            title="Apple Health and Fitness"
            description="Save each session as a strength training workout. Optional, and off until you turn it on."
          />
          <CardGrid.IconCard
            maxWidth="third"
            iconName="save"
            title="Your backup, your file"
            description="Export everything to a JSON file and import it back whenever you want."
          />
          <CardGrid.IconCard
            maxWidth="third"
            iconName="lock"
            title="Private by design"
            description="No account, no ads, no tracking. Your data never reaches us."
          />
          <CardGrid.IconCard
            maxWidth="third"
            iconName="contrast"
            title="Light or dark"
            description="Follow your device or pick the appearance you prefer."
          />
          <CardGrid.IconCard
            maxWidth="third"
            iconName="translate"
            title="English and French"
            description="The whole app is translated, from your trainings to your stats."
          />
        </CardGrid>
      </Section>

      <Section title="Ready for your next session?" paddingTop={60} paddingBottom={160}>
        <div className={styles.storeButtons}>
          <DownloadActionButton size="medium" label={DOWNLOAD_LABEL} />
        </div>
        {APP_ID === null && (
          <p className={styles.betaNote}>
            Carac is free and currently in public beta on TestFlight.
          </p>
        )}
      </Section>
    </>
  );
}
