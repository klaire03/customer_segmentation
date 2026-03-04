# Smartwatch Customer Segmentation

Unsupervised machine learning project using K-Means clustering to identify distinct customer personas from a UK smartwatch survey. Built to answer two questions: what types of smartwatch owner exist, and what types of prospective buyer exist?

---

## Overview

| | |
|---|---|
| **Dataset** | 996 UK adult survey responses |
| **Features** | 51 (demographics, device profile, lifestyle, attitudes, purchase intent) |
| **Method** | K-Means clustering, separate pipelines for owners and non-owners |
| **Output** | 5 owner personas · 4 non-owner personas |
| **Tools** | Python · pandas · scikit-learn · UMAP · matplotlib · seaborn |

---

## Key technical decisions

**Ordinal encoding over one-hot**
35+ columns use Likert scales with a natural order. One-hot encoding destroys that structure — the model would treat *Very important* as equally different from both *Extremely important* and *Not at all important*. Ordinal encoding (0–4) preserves rank. Result: silhouette score improved from 0.06 → 0.22, a 3.5× gain in cluster quality.

**Owners and non-owners analysed separately**
Non-owners have no data for watch satisfaction, spend, wear frequency, or churn — those questions weren't asked. Merging both groups would mean imputing values for 23% of the sample. The two groups also answer different questions: owners → loyalty and churn risk; non-owners → barriers to first purchase.

**Median imputation, not zero**
Zero means *lowest possible answer* on an ordinal scale — filling missing values with zero would falsely imply the worst response for every gap. The column median is neutral and doesn't push clusters toward extremes.

**Interpretability over metric peak for K selection**
Elbow method and silhouette score were tested across K=2–8 (owners) and K=2–6 (non-owners). K=5 (owners) and K=4 (non-owners) were chosen — not because they had the best silhouette scores, but because higher K values produced clusters too small to support distinct, nameable personas. Always check cluster sizes alongside the metric.

**PCA before UMAP**
With 80 features, running UMAP directly is slow and noisy. PCA first reduces to 30 components, removing noise and speeding up UMAP significantly.

---

## Personas

### Current owners (n=769)

| Persona | n | Description |
|---|---|---|
| 🏋️ **Active Brand Explorers** | 172 (22%) | Active and health-conscious but low satisfaction — bought cheap and ready to upgrade. Eyeing both Fossil and Samsung. |
| 🚉 **Passive & Disengaged** | 29 (4%) | Happy Ticwatch owners who tap-to-pay and check notifications on the train. No fitness interest whatsoever. |
| 😌 **Satisfied Casual Users** | 56 (7%) | Recent Samsung phone users, high satisfaction, use it for navigation and connectivity. Low churn risk. |
| 🤖 **Android Everyday Users** | 201 (26%) | Google Pixel users who cycle to work and want affordable navigation. Lowest spend and lowest upgrade budget of any group. |
| 💎 **Premium & Connected Buyers** | 311 (40%) | Highest spend, highest upgrade budget. Emergency SOS and smart device integration matter. Apple/iOS ecosystem. |

### Non-owners (n=227)

| Persona | n | Description |
|---|---|---|
| 💪 **Tech-Curious Gym-Goers** | 28 (12%) | Strength trainers drawn to Samsung's design. Emergency features score highly. More a product-fit problem than category resistance. |
| 🏃 **Health-Motivated Actives** | 142 (63%) | Already active and health-aware but not yet convinced. No single barrier — general awareness and value communication problem. |
| 🧘 **Mindful & Mobile** | 28 (12%) | High meditation, moderate exercise, drives or cycles. Interested in smart home integration, not performance tracking. |
| 💼 **Productivity-Driven Professionals** | 29 (13%) | Want notifications, phone independence, smart device control. Already interested in Apple. Fitness entirely absent. |

---

## Insights & recommendations

**1. Most owners are premium-oriented, not value-driven.**
40% are Premium & Connected Buyers and another 22% are actively upgrading — over 60% have genuine upgrade potential. Lead with ecosystem and safety (emergency SOS, smart home, Apple/Android sync) for the premium segment; run trade-in campaigns comparing budget devices to mid-range alternatives for upgraders.

**2. Fitness is not a universal motivation.**
Three of five owner clusters and two of four non-owner clusters show weak or negative fitness signals — a fitness-first strategy reaches maybe 30–40% of this market. Passive & Disengaged owners respond only to tap-to-pay and commuter messaging; Productivity-Driven Professionals convert on calendar, Siri, and hands-free calls instead.

**3. The biggest non-owner group has no single clear barrier.**
Health-Motivated Actives (63% of non-owners) are already active but unconvinced. Broad benefit-led campaigns across brands and price points, with free trials to reduce friction, are the right approach here.

**4. Two non-owner groups are ready to convert now.**
Productivity-Driven Professionals already want Apple — pitch it as a professional tool, not a health device. Mindful & Mobile map directly onto Fitbit/Garmin wellness features (sleep, stress, breathing). Together they're 25% of non-owners who don't need convincing on the category.

**5. Android Everyday Users are a retention problem, not an upsell one.**
Lowest spend, lowest upgrade budget, lowest engagement with premium features. Practical ecosystem-focused retention messaging with a loyalty offer at renewal beats any upsell campaign.

---

## Approach
```python
# Pipeline overview
1. Load & clean          # Fix string 'NA' nulls, UTF-8 encoding bug in frequency_wear
2. Split groups          # Owners (n=769) and non-owners (n=227) analysed separately  
3. Ordinal encoding      # 13 custom scale maps preserving rank order across 35+ columns
4. One-hot encoding      # Nominal columns only: brand, OS, churn reason, living situation
5. Median imputation     # Neutral fill — avoids implying worst-case for missing values
6. StandardScaler        # Fit separately per group to avoid data leakage
7. K selection           # Elbow + silhouette tested; final K chosen on interpretability
8. KMeans fit            # random_state=42, n_init='auto'
9. Lift analysis         # Cluster mean − population mean; ranked by mean absolute lift
10. Naming               # Manual, based on top positive and negative lift signals
11. Visualisation        # UMAP scatter · heatmap · feature bar chart · radar chart
12. Export               # owners_segmented.csv · nonowners_segmented.csv
```

---

## Limitations

- **Silhouette scores are moderate** (owners: 0.217 at K=5) — typical for survey data. Treat personas as dominant tendencies, not rigid boxes.
- **Non-owner sample is small** — three of four clusters have ~28 people each. Findings are directional.
- **Stated preference data** — people overstate feature interest and understate price sensitivity. Behavioural data (purchases, returns, app usage) would sharpen these findings.
