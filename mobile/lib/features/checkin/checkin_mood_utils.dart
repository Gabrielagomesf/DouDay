/// Humor DuoDay (doc): Feliz, Neutro, Triste, Cansado, Estressado → API + scores.
double moodToScore(String mood) {
  switch (mood) {
    case 'very_good':
      return 5;
    case 'good':
      return 4;
    case 'neutral':
      return 3;
    case 'sad':
      return 2;
    case 'tired':
      return 2;
    case 'stressed':
      return 1;
    default:
      return 3;
  }
}

String moodLabelPt(String mood) {
  switch (mood) {
    case 'very_good':
      return 'Feliz';
    case 'good':
      return 'Bem';
    case 'neutral':
      return 'Neutro';
    case 'sad':
      return 'Triste';
    case 'tired':
      return 'Cansado';
    case 'stressed':
      return 'Estressado';
    default:
      return mood;
  }
}

String scoreToShortLabel(double avg) {
  if (avg >= 4.5) return 'Feliz';
  if (avg >= 3.5) return 'Neutro';
  if (avg >= 2.5) return 'Neutro';
  if (avg >= 1.5) return 'Cansado';
  return 'Estressado';
}
