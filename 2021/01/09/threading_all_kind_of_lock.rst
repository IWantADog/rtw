public: yes
tags: [python, threading, lock]
summary: |
    python线程库的各种锁的特点记录及 Semaphore、Event、Barrier功能记录。

python线程库的各种锁的特点记录
==============================

Lock
------

1. 某一线程 ``acquire`` **Lock** 后并不占用锁，其他任意线程都可 ``release`` 锁。
2. **Lock** 只能被同一线程 ``acquire`` 一次，如果再次 ``acquire`` 会被阻塞（前提是 ``block=True`` ）。
3. ``release`` 一个未 ``acquire`` 的锁时，抛出 ``RuntimeError``。

Rlock
-------

1. 某一线程 ``acquire`` **Rlock** 后占用锁，只有获取锁的线程可以 ``release`` 锁。其他线程不可 ``release`` 该锁，如果线程企图释放一个其未获取的锁，线程会抛出 ``RuntimeError``。
2. 同一线程可多次 ``acquire`` 锁，且不会被阻塞。线程 ``acquire`` 与 ``release`` 的次数必须相同。


Condition
-----------

1. ``Condition`` 包含一个锁 ``Lock or Rlock`` 。调用者可选择传入一个锁，或是使用默认的锁（``Rlock``）。 ``Condition`` 包含的锁是它本身的一部分，使用者不必单独跟踪传入的锁。
2. ``wait`` 和 ``notify`` 的内部逻辑。线程通过 ``acquire()`` 获取锁，执行到达 ``wait()`` 后释放获得的锁，并将当前线程阻塞，等待其他线程通过 ``notify()`` 或 ``notify_all()`` 将其唤醒。如果 ``wait()`` 设置了 ``timeout`` 则阻塞相应的时间，时间耗尽后线程未被唤醒，则返回 ``False`` ；若未设置 ``timeout`` 则阻塞线程直到被唤醒。线程被唤醒之后重新获取锁返回 ``True`` 执行之后的逻辑。最后线程通过 ``release()`` 释放锁。

3. ``notify`` 和 ``notify_all`` **唤醒线程但不释放锁** 。被唤醒的线程需要等待锁被 ``release()`` 释放之后，才能获取锁。

4. 根据实际需要选择 ``notify`` 和 ``notify_all`` 。

代码示例::

    # Consume one item
    with cv:
        while not an_item_is_available():
            cv.wait()
        get_an_available_item()

    # Produce one item
    with cv:
        make_an_item_available()
        cv.notify()


Semaphore
----------------

1. ``Semaphore(value=1)`` 内部维持了一个 **原子计数器** 。``acquire()`` 和 ``release()`` 分别在计数器上 **减** 和 **加** 。
2. ``acquire()`` 被调用时首先判断计数器是否为0，如果为0则阻塞当前线程，直到其他的线程调用 ``release()``；反之在计数器上减1。
3. ``release()`` 在计数器上加n，如果当前计数器为0，并且有等待的线程，则唤醒n个线程。
4. ``BoundedSemaphore(value=1)`` 有界信号量。如果当前计数器超过了初始技术器，则线程抛出 ``ValueError``


Event Object
----------------

1. 最简单的线程间通讯方式。``Event`` 内部维持了一个 ``flag`` (默认为 ``False``)。
2. ``set()`` 将 ``flag`` 置为 ``True``。
3. ``clear()`` 将 ``flag`` 置为 ``False``。
4. ``wait()`` 等待 ``flag`` 为 ``True`` 。支持阻塞和超时功能。返回值为 ``Boolean`` 。


Barrier
----------

1. ``Barrier`` 实现了这样的功能：固定数量的线程相互等待，待所有线程都进入等待状态，则将所有线程同时释放。


Reference
--------------

`python official document -- threading <https://docs.python.org/3/library/threading.html>`_

`What is the difference between Lock and RLock <https://stackoverflow.com/questions/22885775/what-is-the-difference-between-lock-and-rlock>`_




