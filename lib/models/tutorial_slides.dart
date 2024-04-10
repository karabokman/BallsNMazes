class Tutorial {
  final String assetPath;
  final String description;
  final String title;

  Tutorial(
      {required this.assetPath,
      required this.description,
      required this.title});

  static final Set<Tutorial> slides = {
    Tutorial(
        assetPath: 'assets/images/Misc/Movement.png',
        description:
            'Drag on the screen and a joystick will appear which you can use to move the ball to your desired direction.',
        title: 'Movement'),
    Tutorial(
        assetPath: 'assets/images/Misc/Painters.png',
        description:
            'Touch the paint brush with the ball to change the colour of the ball.',
        title: 'Painters'),
    Tutorial(
        assetPath: 'assets/images/Misc/Objective.png',
        description:
            'The aim is to reach the checkpoint. The colour of the checkpoint should match with the colour of the ball to complete the level.',
        title: 'Objective'),
    Tutorial(
        assetPath: 'assets/images/Misc/Logo-2.png',
        description: 'You have 4 minutes to complete each level.',
        title: 'Timer'),
    Tutorial(
        assetPath: 'assets/images/Misc/Time-Out.png',
        description:
            'The colour of the checkpoint changes randomly every minute.',
        title: 'Checkpoint time out'),
    Tutorial(
        assetPath: 'assets/images/Misc/Ghost-Mode.png',
        description:
            'Tap the ball to go into Ghost Mode. In this mode you can pass through walls. Note Ghost mode lasts a short time so use it wisely.',
        title: 'Ghost Mode'),
    Tutorial(
        assetPath: 'assets/images/Misc/Logo-1.png',
        description:
            'You get a Gold medal or Silver medal if you finish the level quickly. Bronze is awarded if you just complete the level before the timer runs out.',
        title: 'Medals'),
  };
}
