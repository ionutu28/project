import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.util.ArrayList;

public class GamePanel extends JPanel implements ActionListener {
    private final int tileSize = 25;
    private final int gameWidth = 600, gameHeight = 600;
    private final ArrayList<Point> snake = new ArrayList<>();
    private Point food;
    private boolean running = false;
    private Timer timer;
    private int score = 0;

    private enum Direction { UP, DOWN, LEFT, RIGHT }
    private Direction direction = Direction.RIGHT;

    public GamePanel() {
        this.setPreferredSize(new Dimension(gameWidth, gameHeight));
        this.setBackground(Color.BLACK);
        this.setFocusable(true);
        this.addKeyListener(new KeyAdapter() {
            @Override
            public void keyPressed(KeyEvent e) {
                changeDirection(e.getKeyCode());
            }
        });
        startGame();
    }

    private void startGame() {
        snake.clear();
        snake.add(new Point(tileSize * 5, tileSize * 5));
        spawnFood();
        running = true;
        timer = new Timer(100, this);
        timer.start();
    }

    private void spawnFood() {
        int x = (int) (Math.random() * (gameWidth / tileSize)) * tileSize;
        int y = (int) (Math.random() * (gameHeight / tileSize)) * tileSize;
        food = new Point(x, y);
    }

    private void changeDirection(int keyCode) {
        switch (keyCode) {
            case KeyEvent.VK_UP:
                if (direction != Direction.DOWN) direction = Direction.UP;
                break;
            case KeyEvent.VK_DOWN:
                if (direction != Direction.UP) direction = Direction.DOWN;
                break;
            case KeyEvent.VK_LEFT:
                if (direction != Direction.RIGHT) direction = Direction.LEFT;
                break;
            case KeyEvent.VK_RIGHT:
                if (direction != Direction.LEFT) direction = Direction.RIGHT;
                break;
        }
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        if (running) {
            move();
            checkCollision();
            checkFood();
        }
        repaint();
    }

    private void move() {
        Point head = snake.get(0);
        Point newHead = new Point(head);

        switch (direction) {
            case UP:
                newHead.y -= tileSize;
                break;
            case DOWN:
                newHead.y += tileSize;
                break;
            case LEFT:
                newHead.x -= tileSize;
                break;
            case RIGHT:
                newHead.x += tileSize;
                break;
        }

        snake.add(0, newHead);
        snake.remove(snake.size() - 1);
    }

    private void checkCollision() {
        Point head = snake.get(0);
        if (head.x < 0 || head.x >= gameWidth || head.y < 0 || head.y >= gameHeight) {
            stopGame();
        }
        for (int i = 1; i < snake.size(); i++) {
            if (head.equals(snake.get(i))) {
                stopGame();
            }
        }
    }

    private void checkFood() {
        if (snake.get(0).equals(food)) {
            snake.add(new Point(-1, -1));
            score++;
            spawnFood();
        }
    }

    private void stopGame() {
        running = false;
        timer.stop();
        JOptionPane.showMessageDialog(this, "Game Over! Score: " + score);
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        if (running) {
            g.setColor(Color.RED);
            g.fillRect(food.x, food.y, tileSize, tileSize);

            g.setColor(Color.GREEN);
            for (Point p : snake) {
                g.fillRect(p.x, p.y, tileSize, tileSize);
            }
        }
    }
}
